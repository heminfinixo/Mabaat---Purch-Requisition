pageextension 50157 "UserSetupExt_IXO" extends "User Setup"
{
    layout
    {

        addbefore(Email)
        {


        }
    }

    actions
    {
        addfirst(Processing)
        {
            action("Req. Workflow User Group_IXO")
            {
                ApplicationArea = All;
                Image = WorkflowSetup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Req Workflow User Group_IXO";
                RunPageLink = USERID = field("User ID");
                Caption = 'Req. Workflow User Group';


                trigger OnAction()
                var

                begin

                end;

            }

        }
    }

    var

}