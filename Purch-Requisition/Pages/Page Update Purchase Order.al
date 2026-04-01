page 50170 "Update Purchase Document_IXO"
{
    PageType = StandardDialog;
    // ApplicationArea = All;
    //  UsageCategory = Administration;
    //SourceTable = TableName;

    layout
    {
        area(Content)
        {
            group("Select Purchase Order")
            {
                field("Document No."; DocumentNo)
                {
                    ApplicationArea = All;

                    TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
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
        if CloseAction = CloseAction::OK then;

    end;


    var

        DocumentNo: Code[20];


    procedure "Update Order Lines"(IncomingLine: Record "Purchase Requisition Line_IXO"; Cont: Code[20])
    var
        PurchLine: Record "Purchase Line";
        POheader: Record "Purchase Header";
        findLast1: Record "Purchase Line";

    begin

        // PurchLine.SetFilter("Document No.", Cont);
        /*  IF PurchLine.FindFirst() then
             IF IncomingLine."Vendor No." <> PurchLine."Buy-from Vendor No." then
                 Error('You have choosen an Item %1 to Update in a Purchase Order %2 for a different vendor.', IncomingLine.Description, PurchLine."Document No."); */

        //  WITH PurchLine do begin

        PurchLine.Init();
        findLast1.Reset();
        findLast1.SetRange("Document Type", findLast1."Document Type"::Order);
        findLast1.SetFilter("Document No.", Cont);
        //  findLast1.SetFilter("Document No.", Cont);
        IF findLast1.FindLast() then
            PurchLine."Line No." := findLast1."Line No." + 10000;
        PurchLine."Document Type" := PurchLine."Document Type"::Order;
        PurchLine."Document No." := Cont;
        IF IncomingLine.Type = IncomingLine.Type::Item then
            PurchLine.Type := PurchLine.Type::Item;
        PurchLine.Validate(PurchLine."No.", IncomingLine."No.");
        PurchLine.Validate(PurchLine.Quantity, IncomingLine.Quantity);
        PurchLine.Validate(PurchLine."Location Code", IncomingLine.Location);
        PurchLine.Validate(PurchLine."Direct Unit Cost", IncomingLine."Unit Cost");
        PurchLine."Req. Document No._IXO" := IncomingLine."Document No.";
        PurchLine."Purch. Req. Line No._IXO" := IncomingLine."Line No.";
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
        POheader.SetFilter("Document Type", 'Order');
        POheader.SetRange("No.", PurchLine."Document No.");
        IF POheader.FindFirst() then
            IF Dialog.Confirm('Purchase Order %1 Succesfully Updated. \Do you want to Open?', true, POHeader."No.") then
                Page.RunModal(page::"Purchase Order", POheader);


    end;

}