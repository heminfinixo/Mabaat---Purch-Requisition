page 50169 "Update Purchase Invoice_IXO"
{
    PageType = StandardDialog;
    //  ApplicationArea = All;
    //  UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(DocumentNo; DocumentNo)
                {
                    ApplicationArea = All;
                    TableRelation = "Purchase Header"."No." where("Document Type" = const(Invoice));
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


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var

    begin

    end;

    var
        POheader: Record "Purchase Header";
        DocumentNo: Code[20];


    procedure "Update Invoice Lines"(IncomingLine: Record "Purchase Requisition Line_IXO"; Cont: Code[20])
    var
        PurchLine: Record "Purchase Line";
    begin

        //PurchLine.SetFilter("Document No.", Cont);

        //  WITH PurchLine do begin

        PurchLine.Init();
        PurchLine.SetFilter("Document No.", Cont);
        IF PurchLine.FindLast() then
            PurchLine."Line No." := PurchLine."Line No." + 10000;
        PurchLine."Document Type" := PurchLine."Document Type"::Invoice;
        PurchLine."Document No." := Cont;
        IF IncomingLine.Type = IncomingLine.Type::Item then
            PurchLine.Type := PurchLine.Type::Item;
        PurchLine.Validate(PurchLine."No.", IncomingLine."No.");
        PurchLine.Validate(PurchLine.Quantity, IncomingLine.Quantity);
        PurchLine.Validate(PurchLine."Location Code", IncomingLine.Location);
        PurchLine.Validate(PurchLine."Direct Unit Cost", IncomingLine."Unit Cost");
        PurchLine."Req. Document No._IXO" := IncomingLine."Document No.";
        PurchLine.Validate("Shortcut Dimension 1 Code", IncomingLine."Shortcut Dimension 1 Code");
        PurchLine.Validate("Shortcut Dimension 2 Code", IncomingLine."Shortcut Dimension 2 Code");
        PurchLine.ValidateShortcutDimCode(3, IncomingLine."Shortcut Dimension 3 Code");
        PurchLine.ValidateShortcutDimCode(4, IncomingLine."Shortcut Dimension 4 Code");
        PurchLine.ValidateShortcutDimCode(5, IncomingLine."Shortcut Dimension 5 Code");
        PurchLine.ValidateShortcutDimCode(6, IncomingLine."Shortcut Dimension 6 Code");
        PurchLine.ValidateShortcutDimCode(7, IncomingLine."Shortcut Dimension 7 Code");
        PurchLine.ValidateShortcutDimCode(8, IncomingLine."Shortcut Dimension 8 Code");
        PurchLine.Insert();

        //end;
        Commit();
        POheader.SetFilter("Document Type", 'Invoice');
        POheader.SetRange("No.", PurchLine."Document No.");
        IF POheader.FindFirst() then
            IF Dialog.Confirm('Purchase Order %1 Succesfully Updated. \Do you want to Open?', true, POHeader."No.") then
                Page.RunModal(page::"Purchase Invoice", POheader);
    END;

}