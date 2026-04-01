#pragma implicitwith disable
page 50151 "Purchase Req. Subform_IXO"
{
    PageType = ListPart;
    SourceTable = "Purchase Requisition Line_IXO";
    // AdditionalSearchTerms = 'Purchase Requsition Subform';
    Caption = 'Purchase Requsition Subform';
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    SourceTableView = WHERE("Document Type" = filter(Purchase));

    layout
    {
        area(Content)
        {

            repeater(GroupName)
            {

                /*  field("Document Type"; "Document Type")
                 {
                     ApplicationArea = All;

                 }

                 field("Document No."; "Document No.")
                 {
                     ApplicationArea = All;

                 } */
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;



                    /* 
                                            IF (Rec.Status = Status::"Pending Approval") or (Rec.Status = Status::Approved) then
                                                Error('Document Should be ''Open'''); */

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                /*   field("Description 2"; "Description 2")
                  {
                      ApplicationArea = All;
                  } */
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field("Unit Of Measure Code"; Rec."Unit Of Measure Code")
                {
                    ApplicationArea = All;
                    TableRelation = "Unit of Measure";
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var

                    begin
                        Rec.Amount := Rec.Quantity * Rec."Unit Cost";
                        CurrPage.SaveRecord();


                    end;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var

                    begin
                        Rec.Amount := Rec.Quantity * Rec."Unit Cost";
                        CurrPage.SaveRecord();
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var

                    begin
                        Rec.Amount := Rec.Quantity * Rec."Unit Cost";
                        CurrPage.SaveRecord();

                    end;

                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,1';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
                    Visible = visibleShortcutDimension1;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,2';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
                    Visible = visibleShortcutDimension2;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
                    Visible = visibleShortcutDimension3;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
                    Visible = visibleShortcutDimension4;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
                    Visible = visibleShortcutDimension5;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
                    Visible = visibleShortcutDimension6;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
                    Visible = visibleShortcutDimension7;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
                    Visible = visibleShortcutDimension8;
                    //Editable = NotEditable;
                }
            }
            group(Something)
            {

            }

        }
    }

    actions
    {

        area(Processing)
        {
            group("File Attachment")
            {
                Caption = 'File Attachment';
                action("Upload Attachment")
                {
                    ApplicationArea = All;
                    Image = Attachments;
                    // Promoted = true;
                    // PromotedCategory = Process;
                    ToolTip = 'You can Upload any file type. To upload multiple files at once, bundle it in .rar';

                    trigger OnAction()
                    var
                        recLine: Record "Purchase Requisition Line_IXO";
                        DocumentAttachment: Codeunit "FileUploadDownload_IXO";


                    begin
                        CurrPage.SetSelectionFilter(recLine);
                        IF recLine.FindFirst() then
                            DocumentAttachment.UploadAttachment(recLine."Line No.", recLine."No.", Rec."Document No.");

                        // DocumentAttachment.OpenAttachment(Rec."Line No.", Rec."Document No.");

                    end;

                }
                action("Download Attachment")
                {
                    ApplicationArea = All;
                    Image = Attachments;
                    //Promoted = true;
                    // PromotedIsBig = true;
                    // PromotedCategory = Process;

                    trigger OnAction()
                    var
                        recLine: Record "Purchase Requisition Line_IXO";
                        DocumentAttachment: Codeunit "FileUploadDownload_IXO";


                    begin
                        CurrPage.SetSelectionFilter(recLine);
                        IF recLine.FindFirst() then
                            DocumentAttachment.OpenAttachment(recLine."Line No.", Rec."Document No.");

                        // DocumentAttachment.OpenAttachment(Rec."Line No.", Rec."Document No.");

                    end;

                }
            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var

    begin
        Rec.Type := Rec.Type::Item;
    end;



    var
        visibleShortcutDimension1: Boolean;
        visibleShortcutDimension2: Boolean;
        visibleShortcutDimension3: Boolean;
        visibleShortcutDimension4: Boolean;
        visibleShortcutDimension5: Boolean;
        visibleShortcutDimension6: Boolean;
        visibleShortcutDimension7: Boolean;
        visibleShortcutDimension8: Boolean;

    trigger OnOpenPage()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();

        if GLSetup."Shortcut Dimension 7 Code" = '' then
            visibleShortcutDimension7 := false
        else
            visibleShortcutDimension7 := true;
        if GLSetup."Shortcut Dimension 1 Code" = '' then
            visibleShortcutDimension1 := false
        else
            visibleShortcutDimension1 := true;
        if GLSetup."Shortcut Dimension 2 Code" = '' then
            visibleShortcutDimension2 := false
        else
            visibleShortcutDimension2 := true;
        if GLSetup."Shortcut Dimension 3 Code" = '' then
            visibleShortcutDimension3 := false
        else
            visibleShortcutDimension3 := true;
        if GLSetup."Shortcut Dimension 4 Code" = '' then
            visibleShortcutDimension4 := false
        else
            visibleShortcutDimension4 := true;
        if GLSetup."Shortcut Dimension 5 Code" = '' then
            visibleShortcutDimension5 := false
        else
            visibleShortcutDimension5 := true;
        if GLSetup."Shortcut Dimension 6 Code" = '' then
            visibleShortcutDimension6 := false
        else
            visibleShortcutDimension6 := true;
        if GLSetup."Shortcut Dimension 8 Code" = '' then
            visibleShortcutDimension8 := false
        else
            visibleShortcutDimension8 := true;


    end;




}
#pragma implicitwith restore
