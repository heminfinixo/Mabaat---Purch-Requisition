#pragma implicitwith disable
pageextension 50151 "ItemInvoiceFactboxExt_IXO" extends 9089
{
    layout
    {
        addlast(Content)
        {
            field("Inventory_IXO"; Rec.Inventory)
            {
                ApplicationArea = All;
            }
            field("Qty. on Sales Order_IXO"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = All;
            }
            field("Qty. on Prod. Order_IXO"; Rec."Qty. on Prod. Order")
            {
                ApplicationArea = All;
            }
            field("Qty. on Component Lines_IXO"; Rec."Qty. on Component Lines")
            {
                ApplicationArea = All;

            }
            field("Qty. on Asm. Component_IXO"; Rec."Qty. on Asm. Component")
            {
                ApplicationArea = All;
            }
            field("Net Invoiced Qty._IXO"; Rec."Net Invoiced Qty.")
            {
                ApplicationArea = All;
            }
            field("Qty. on Service Order_IXO"; Rec."Qty. on Service Order")
            {
                ApplicationArea = All;
            }
            field("Qty. on Assembly Order_IXO"; Rec."Qty. on Assembly Order")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {

    }

    var
}
#pragma implicitwith restore
