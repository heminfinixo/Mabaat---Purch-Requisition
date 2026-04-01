#pragma implicitwith disable
page 50167 "Req Workflow User Group_IXO"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Requisitions Workflow User Group';
    UsageCategory = Administration;
    SourceTable = "Req Workflow User Group_IXO";
    AutoSplitKey = true;


    layout
    {
        area(Content)
        {
            repeater("Req Workflow User Group_IXO")
            {
                /*  field(USERID; USERID)
                 {
                     ApplicationArea = All;
                     Editable = false;

                 }
                 field("Line No."; "Line No.")
                 {
                     ApplicationArea = All;
                     Editable = false;
                 } */
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Workflow User Group"; Rec."Workflow User Group")
                {
                    ApplicationArea = All;

                }

                field(Enable; Rec.Enable)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var

                    begin
                        if Rec."Workflow User Group" = '' then
                            Error('Workflow User Cannot be Empty');
                    end;
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

}
#pragma implicitwith restore
