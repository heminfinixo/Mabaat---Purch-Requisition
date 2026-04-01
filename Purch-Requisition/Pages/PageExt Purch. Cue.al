#pragma implicitwith disable
pageextension 50152 "Purchase Agent Ext_IXO" extends "Purchase Agent Activities"
{
    layout
    {
        addafter("Pre-arrival Follow-up on Purchase Orders")
        {
            cuegroup("Purch./Material Pending Approval Requests_IXO")
            {
                Caption = 'Purch./Material Pending Approval Requests';
                field("Requistions Approvals_IXO"; Rec."Requistions Approvals_IXO")
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                    Caption = 'Req. Approvals';
                    trigger OnDrillDown()

                    var

                    begin
                        Page.Run(Page::"Req. Approval Entries_IXO");

                    end;


                }
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var

}
#pragma implicitwith restore
