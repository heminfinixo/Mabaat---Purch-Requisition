table 50153 "Purchase Requisition Line_IXO"
{

    DataClassification = ToBeClassified;

    fields
    {

        field(1; "Line No."; Integer)
        {

            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(3; "Vendor No."; Code[20])
        {

            // TableRelation = Vendor;
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin

                if "Vendor No." <> '' then begin

                    Vend.GET("Vendor No.");
                    "Vendor Name" := Vend.Name;

                end;

                // if (Status = Status::"Pending Approval") or (Status = Status::Approved) then
                // Error('Bla');
            end;
            // CalcFormula = lookup ("Purchase Req. Header_IXO"."Vendor No." where ("Document No." = field ("Document No.")));
        }
        field(4; "Vendor Name"; Text[50])
        {

            //Editable = false;
            DataClassification = CustomerContent;
            //TableRelation = Vendor;
            // CalcFormula = lookup ("Purchase Req. Header_IXO"."Vendor Name" where ("Document No." = field ("Document No.")));
        }
        field(5; "Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Item";
            OptionCaption = 'Comment, Item';

        }
        field(6; "No."; Code[20])
        {
            //DataClassification = CustomerContent;
            TableRelation =/*  IF (Type = CONST (" "))
            //ELSE IF (Type = CONST ("G/L Account")) "G/L Account" WHERE ("Direct Posting" = CONST (True), "Account Type" = CONST (Posting), Blocked = CONST (False)) 
            ELSE */
            IF (Type = CONST(Item)) Item;
            trigger OnValidate()
            var
                ItemContainer: Record Item;
            begin

                IF (Type = Type::Item) then begin
                    ItemContainer.GET(Rec."No.");
                    if ItemContainer.Type <> ItemContainer.Type::Inventory then begin
                        if "Document Type" = "Document Type"::Material then
                            Error('Item type must be inventory');
                    end;
                    Description := ItemContainer.Description;
                    //"Description 2" := ItemContainer."Description 2";
                    "Unit Of Measure Code" := ItemContainer."Base Unit of Measure";
                    "Unit Cost" := ItemContainer."Last Direct Cost";
                end
            end;


        }
        field(7; "Description"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Description 2"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Location"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;


        }
        field(10; "Unit of Measure Code"; Code[10])
        {
            DataClassification = CustomerContent;

        }
        field(11; "Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(12; "Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            var

            begin
                Amount := Rec.Quantity * Rec."Unit Cost";
            end;
        }
        field(13; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            var
            begin
                "Unit Cost" := Amount / Quantity;

            end;

        }
        field(14; "Quantity to Request"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;

        }
        field(15; "Quantity Requested"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(16; "Outstanding Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(17; "Posting Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Req. Header_IXO"."Posting Date" where("Document No." = field("Document No.")));
        }
        field(18; "Document Type"; Enum "Purch. Req. Doc Type")
        {
            DataClassification = CustomerContent;

        }
        field(19; "Status"; Option)
        {
            FieldClass = FlowField;
            OptionMembers = "Open","Approved","Pending Approval","Rejected","Processed","Partially Processed";
            CalcFormula = lookup("Purchase Req. Header_IXO".Status where("Document No." = field("Document No.")));
        }
        field(20; "Partially Processed"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(21; "Reason Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
        }

        field(22; "Job No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Job;
        }
        field(23; "Job Task No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = field("Job No."));
        }
        field(24; "Service Request Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(34; "Service Request No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(25; "Shortcut Dimension 1 Code"; Code[20])
        {
            // CaptionClass = '1,2,1';
            // Caption = 'Shortcut Dimension 1 Code';
            // TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            //TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;

        }
        field(26; "Shortcut Dimension 2 Code"; Code[20])
        {
            // CaptionClass = '1,2,2';
            // Caption = 'Shortcut Dimension 2 Code';
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;

        }
        field(27; "Shortcut Dimension 3 Code"; Code[20])
        {
            // CaptionClass = '1,2,3';
            // Caption = 'Shortcut Dimension 3 Code';
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            DataClassification = CustomerContent;

            // trigger OnValidate()
            // var
            // DimValue:Record "Dimension Value";
            // begin
            //     Validate("Shortcut Dimension 3 Code",DimValue."Global Dimension No.":);
            // end;
        }
        field(28; "Shortcut Dimension 4 Code"; Code[20])
        {
            // CaptionClass = '1,2,4';
            // Caption = 'Shortcut Dimension 4 Code';
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
            DataClassification = CustomerContent;
        }
        field(29; "Shortcut Dimension 5 Code"; Code[20])
        {
            // CaptionClass = '1,2,5';
            // Caption = 'Shortcut Dimension 5 Code';
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
            DataClassification = CustomerContent;
        }
        field(30; "Shortcut Dimension 6 Code"; Code[20])
        {
            // CaptionClass = '1,2,6';
            // Caption = 'Shortcut Dimension 6 Code';
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
            DataClassification = CustomerContent;
        }
        field(31; "Shortcut Dimension 7 Code"; Code[20])
        {
            // CaptionClass = '1,2,7';
            // Caption = 'Shortcut Dimension 7 Code';
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
            DataClassification = CustomerContent;
            // FieldClass = FlowField;
            // CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Global Dimension No." = const(7)));

        }
        field(32; "Shortcut Dimension 8 Code"; Code[20])
        {
            // CaptionClass = '1,2,8';
            // Caption = 'Shortcut Dimension 8 Code';
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
            DataClassification = CustomerContent;

        }
        field(33; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            trigger OnLookup()
            begin
                ShowDimensions();
            end;
        }


        field(97; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';
            Editable = true;
            TableRelation = "No. Series";

            trigger OnValidate();
            begin
                PurchasePayableSetup.Get();
                if "Document No." <> xRec."Document No." then
                    NoSeriesMgt.TestManual(PurchasePayableSetup."Purchase Requisition Nos._IXO")
                else
                    NoSeriesMgt.TestManual(PurchasePayableSetup."Material Requisition Nos._IXO");       //kv add material line code


            end;

        }
        field(35; "Charge to Owner"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        PurchasePayableSetup: Record "Purch. Req. Setup_IXO";
        NoSeriesMgt: Codeunit "No. Series";

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Document No."));
    end;
    // local procedure AssistEdit(): Boolean;
    // // IsHandled: Boolean;
    // begin

    //     PurchasePayableSetup.GET();
    //     PurchasePayableSetup.TESTFIELD(PurchasePayableSetup."Purchase Requisition Nos._IXO");
    //     if rec."Document Type" = Rec."Document Type"::Purchase then begin
    //         if NoSeriesMgt.SelectSeries(PurchasePayableSetup."Purchase Requisition Nos._IXO", xRec."No. Series", "No. Series") then begin
    //             NoSeriesMgt.SetSeries("Document No.");
    //             exit(true);
    //         end;

    //     end else begin
    //         if NoSeriesMgt.SelectSeries(PurchasePayableSetup."Material Requisition Nos._IXO", xRec."No. Series", "No. Series") then begin
    //             NoSeriesMgt.SetSeries("Document No.");
    //             exit(true);
    //         end;

    //     end;
    //end;

    trigger OnInsert()
    var
        recHeader: Record "Purchase Req. Header_IXO";

    begin
        //  Type := Type::Item;

        recHeader.Reset();

        recHeader.SetFilter("Document No.", Rec."Document No.");
        recHeader.SetRange("Document Type", recHeader."Document Type");

        IF NOT (recHeader.Status = recHeader.Status::Open) then
            Error('Action not allowed. Document Status is %1', recHeader.Status);
    end;

    trigger OnModify()
    var
        SingleInstance_CU: Codeunit "Single Instance IXO";
    begin
        Rec.CalcFields(Rec.Status);
        //IF (Rec.Status = Status::"Pending Approval") or (Rec.Status = Status::Approved) then
        if (Rec.Status <> Rec.Status::Open) and (SingleInstance_CU.ReturnMyBool() = false) THEN
            Error('Document must be ''Open''');
        SingleInstance_CU.FromApprovedPagefalse();
    end;

    trigger OnDelete()
    begin
        IF (Rec.Status = Rec.Status::Approved) OR (Rec.Status = Rec.Status::Processed) OR (Rec.Status = Rec.Status::"Pending Approval") OR (Rec.Status = Rec.Status::"Partially Processed") then
            Error('Action not allowed. Document Status is %1', Rec.Status);
        // else
        //     Rec.Delete(); //kv delete add
    end;

    trigger OnRename()
    begin

    end;

    procedure FromApprovedPage()
    var

    begin
        Flag_gBool := true;
        // exit(Flag_gBool);

    end;


    var
        Flag_gBool: Boolean;
        Sap: page "Sales Invoice";

}