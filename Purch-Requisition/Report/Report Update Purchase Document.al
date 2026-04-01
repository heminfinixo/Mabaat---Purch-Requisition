report 50151 "Update Purchase Document_IXO"
{
    //UsageCategory = Administration;
    //  ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItemName; "Purchase Header")
        {
            RequestFilterFields = "Document Type", "No.";
            RequestFilterHeading = 'Select Document Type and Document No.';


            trigger OnPostDataItem()
            var

            begin

            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(DocumentType; DocumentType)
                    {
                        ApplicationArea = All;
                    }
                    field(No; No)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {

            }
        }
    }

    procedure GetRequisitionRec(PurchRequisitionLine: Record "Purchase Requisition Line_IXO")

    begin
        PRline := PurchRequisitionLine;
    end;

    var

        PRline: Record "Purchase Requisition Line_IXO";
        DocumentType: Option "Order","Invoice";
        No: Code[20];
}