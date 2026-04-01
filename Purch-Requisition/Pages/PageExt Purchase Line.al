#pragma implicitwith disable
pageextension 50155 "Purch. Line Ext_IXO" extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shortcut Dimension 2 Code")
        {
            field("Req. Document No._IXO"; Rec."Req. Document No._IXO")
            {
                ApplicationArea = All;
                Editable = false;

            }
            field("Purch. Req. Line No._IXO"; Rec."Purch. Req. Line No._IXO")
            {
                ApplicationArea = All;

                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var

}
#pragma implicitwith restore
