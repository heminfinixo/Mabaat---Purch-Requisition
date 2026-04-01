pageextension 50153 "PurchAgentRoleCentrExt_IXO" extends "Purchasing Agent Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Posted Documents")
        {
            group("Purchase Requisition_IXO")
            {
                Caption = 'Purchase Requisition';
                action("Material Requisition List_IXO")
                {
                    Image = Action;
                    ApplicationArea = All;
                    RunObject = page "Material Requisition_IXO";
                    Caption = 'Material Requisition';

                }
                action("Purchase Requisition List_IXO")
                {
                    Image = Action;
                    ApplicationArea = All;
                    RunObject = page "Purchase Requisition List_IXO";
                    Caption = 'Purchase Requisition';


                }
                action("Requisition - Requests to Approve_IXO")
                {
                    Image = Action;
                    ApplicationArea = All;
                    RunObject = Page "Req. Approval Entries_IXO";
                    Caption = 'Requisition Requests to Approve';


                }
                action("Approved Purchase Requisitions_IXO")
                {
                    Image = Action;
                    ApplicationArea = All;
                    RunObject = page "Approved Purchase Reqs._IXO";
                    Caption = 'Approved Purchase Requisitions';


                }
                action("Approved Material Requisitions_IXO")
                {
                    Image = Action;
                    ApplicationArea = All;
                    RunObject = page "Approved Material Reqs._IXO";
                    Caption = 'Approved Material Requisitions';


                }
                action("Purch Req Setup_IXO")
                {
                    Image = Action;
                    ApplicationArea = All;
                    RunObject = page "Purch. Req. Setup_IXO";
                    Caption = 'Purchase Requisition Setup';


                }
                action("Processed Material_IXO")
                {
                    Image = Action;
                    ApplicationArea = All;
                    RunObject = page "Processed Material List_IXO";
                    Caption = 'Processed Material Requisition';


                }
                action("Processed Purchase_IXO")
                {
                    Image = Action;
                    ApplicationArea = All;
                    RunObject = page "Processed Purchase List_IXO";
                    Caption = 'Processed Purchase Requisition';


                }
                action("Item Journal_IXO")
                {
                    Image = Action;
                    ApplicationArea = All;
                    RunObject = page 40;
                    Caption = 'Item Journal';

                }

            }
        }
    }

    var

}