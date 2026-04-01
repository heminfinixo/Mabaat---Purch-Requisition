#pragma implicitwith disable
pageextension 50156 "Purch & Payables Setup_IXO" extends 295
{
    layout
    {
        addlast(Control1)
        {

            field("No.Series_IXO"; Rec."No.Series_IXO")
            {
                ApplicationArea = All;
            }
            field("Posting No. Series_IXO"; Rec."Posting No. Series_IXO")
            {
                ApplicationArea = All;
            }
            field("Requisition Type_IXO"; Rec."Requisition Type_IXO")
            {
                ApplicationArea = All;
            }


        }
    }

    actions
    {
        // Add changes to page actions here
    }


}
#pragma implicitwith restore
