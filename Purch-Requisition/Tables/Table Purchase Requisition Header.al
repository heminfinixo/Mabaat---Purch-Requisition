table 50152 "Purchase Req. Header_IXO"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Enum "Purch. Req. Doc Type")
        {
            DataClassification = CustomerContent;
            // OptionMembers = "Material","Purchase";
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Vendor No."; Code[20])
        {
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
            end;
        }
        field(4; "Vendor Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = true;

            trigger OnValidate()
            var
            begin
                if (Status = Status::"Pending Approval") or (Status = Status::Approved) then
                    Error('.');
            end;
        }
        field(6; "Created By User"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User;
        }
        field(7; "Created Date Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; "Status"; Option)
        {
            DataClassification = CustomerContent;
            Editable = true;
            OptionMembers = "Open","Approved","Pending Approval","Rejected","Processed","Partially Processed";
        }
        field(9; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Purchaser Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
        field(11; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Requisition Line_IXO".Amount where("Document No." = field("Document No.")));
            Editable = false;
        }
        field(12; "Processed"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Subject"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(14; "Service Request No."; Code[20])
        {
            DataClassification = CustomerContent;
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
                    NoSeriesMgt.TestManual(PurchasePayableSetup."Material Requisition Nos._IXO");           //kv add material requisition line
            end;
        }
    }

    keys
    {
        key(PK; "Document Type", "Document No.")
        {
            Clustered = true;
        }
    }

    var
        Lines: Record "Purchase Requisition Line_IXO";
        Header: Record "Purchase Req. Header_IXO";
        PurchasePayableSetup: Record "Purch. Req. Setup_IXO";
        NoSeriesMgt: Codeunit "No. Series";

    // procedure AssistEdit(): Boolean;   // kv Code done For on assist
    // begin
    //     if "Document No." = '' then begin
    //         PurchasePayableSetup.GET();
    //         PurchasePayableSetup.TESTFIELD(PurchasePayableSetup."Purchase Requisition Nos._IXO");
    //         if rec."Document Type" = Rec."Document Type"::Purchase then begin
    //             if NoSeriesMgt.SelectSeries(PurchasePayableSetup."Purchase Requisition Nos._IXO", xRec."No. Series", "No. Series") then begin
    //                 NoSeriesMgt.SetSeries("Document No.");
    //                 exit(true);

    //             end;

    //         end else begin
    //             if NoSeriesMgt.SelectSeries(PurchasePayableSetup."Material Requisition Nos._IXO", xRec."No. Series", "No. Series") then begin
    //                 NoSeriesMgt.SetSeries("Document No.");
    //                 exit(true);
    //             end;

    //         end;
    //     end;
    // end;


    procedure AssistEdit(): Boolean   // Hem 25/03/2026
    var
        PurchReqNo: Code[20];
    begin
        if "Document No." <> '' then
            exit(false);

        PurchasePayableSetup.GET();
        PurchasePayableSetup.TESTFIELD("Purchase Requisition Nos._IXO");

        if Rec."Document Type" = Rec."Document Type"::Purchase then begin
            PurchReqNo := NoSeriesMgt.GetNextNo(PurchasePayableSetup."Purchase Requisition Nos._IXO");
            if PurchReqNo <> '' then begin
                "Document No." := PurchReqNo;
                exit(true);
            end;
        end else begin
            PurchReqNo := NoSeriesMgt.GetNextNo(PurchasePayableSetup."Material Requisition Nos._IXO");
            if PurchReqNo <> '' then begin
                "Document No." := PurchReqNo;
                exit(true);
            end;
        end;

        exit(false);
    end;

    trigger OnInsert()
    begin
        if "Document No." = '' then begin
            PurchasePayableSetup.GET();
            PurchasePayableSetup.TESTFIELD("Purchase Requisition Nos._IXO");
            IF Rec."Document Type" = Rec."Document Type"::Purchase then
                // NoSeriesMgt.InitSeries(PurchasePayableSetup."Purchase Requisition Nos._IXO", xRec."No. Series", 0D, "Document No.", "No. Series")
                            "Document No." := NoSeriesMgt.GetNextNo(PurchasePayableSetup."Purchase Requisition Nos._IXO") // Hem 24/12/2025

            else
                IF Rec."Document Type" = Rec."Document Type"::Material then
                    //  NoSeriesMgt.InitSeries(PurchasePayableSetup."Material Requisition Nos._IXO", xRec."No. Series", 0D, "Document No.", "No. Series");          //kv
                    "Document No." := NoSeriesMgt.GetNextNo(PurchasePayableSetup."Material Requisition Nos._IXO"); // Hem 24/12/2025
        end;

        "Created Date Time" := CreateDateTime(Today(), Time());
        "Document Date" := WorkDate();
        "Posting Date" := WorkDate();
        "Created By User" := format(UserId());
        /*  iF (PurchasePayableSetup."Default Posting Date" = PurchasePayableSetup."Default Posting Date"::"Work Date") then
             "Posting Date" := WorkDate();

         if (PurchasePayableSetup."Default Posting Date" = PurchasePayableSetup."Default Posting Date"::"No Date") then
             "Posting Date" := 0D; */
    end;

    trigger OnDelete()
    begin
        if NOT (Rec.Status = Rec.Status::Open) then
            Error('Action not allowed. Document Status is %1', Rec.Status)
        else
            Lines.SetRange("Document No.", Rec."Document No.");
        Lines.SetRange("Document Type", Rec."Document Type");//kv add set range

        IF Lines.FindSet() then
            repeat
                Lines.Delete(true);
            //Header.Delete(true);
            until Lines.Next() = 0;
    end;
}