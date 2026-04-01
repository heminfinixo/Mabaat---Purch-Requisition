#pragma implicitwith disable
page 50156 "Approval Entries for User_IXO"
{
    PageType = List;
    Caption = 'Approvals';
    //  ApplicationArea = All;
    // UsageCategory = Lists;
    // Caption = 'Requisition Approval Entries';
    SourceTable = "Req. Approval Entries_IXO";
    /// AdditionalSearchTerms = 'Req Approval Entries';
    Editable = false;
    //  SourceTableView = sorting ("Entry No.") where (Status = filter (Open));


    layout
    {
        area(Content)
        {
            repeater("Approval Entries")
            {
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }

                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }

                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                }

                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                }
                field("Last Modified By User ID"; Rec."Last Modified By User ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}
#pragma implicitwith restore
