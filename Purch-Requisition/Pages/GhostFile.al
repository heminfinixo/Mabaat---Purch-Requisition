/* page 90046 "Approved_IXO"
{
    PageType = List;
    // ApplicationArea = All;
    //  UsageCategory = Lists;
    SourceTable = "Req. Approval Entries_IXO";
    //AdditionalSearchTerms = 'Req Approval Entries';
    SourceTableView = sorting ("Entry No.") where (Status = filter (Open), Status = filter (Rejected), Status = filter (Canceled));
    // SourceTableView = sorting ("Entry No.") where (Status = filter (Open));
    layout
    {
        area(Content)
        {
            repeater("Approval Entries")
            {
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;

                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Last Date-Time Modified"; "Last Date-Time Modified")
                {
                    ApplicationArea = All;
                }
                field("Last Modified By User ID"; "Last Modified By User ID")
                {
                    ApplicationArea = All;
                }
                field("Record ID to Approve"; "Record ID to Approve")
                {
                    ApplicationArea = All;
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                    ApplicationArea = All;
                }
                field("Sender ID"; "Sender ID")
                {
                    ApplicationArea = All;
                }
                field("Sequence No."; "Sequence No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Table ID"; "Table ID")
                {
                    ApplicationArea = All;
                }
                field("Workflow Step Instance ID"; "Workflow Step Instance ID")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Approval Code"; "Approval Code")
                {
                    ApplicationArea = All;
                }
                field("Approver ID"; "Approver ID")
                {
                    ApplicationArea = All;
                }
                field("Available Credit Limit (LCY)"; "Available Credit Limit (LCY)")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }

    var
} */