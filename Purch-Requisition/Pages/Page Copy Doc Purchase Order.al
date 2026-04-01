page 50160 "Copy Purchase Order Page_IXO"
{
    PageType = StandardDialog;
    Caption = 'Copy Exisiting Purchase Order';

    //   ApplicationArea = All;
    //   UsageCategory = Administration;
    // SourceTable = TableName;

    layout
    {
        area(Content)
        {
            group("Select Document to Copy")
            {

                field("Document No."; DocumentNo)
                {
                    ApplicationArea = All;
                    // LookupPageId = "Purchase Order List";

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

    procedure CopyMaterial(RecCode: Code[20])
    var
        recPurchLines: Record "Purchase Line";
        copyRecPurchReqLines: Record "Purchase Requisition Line_IXO";
        TestCode: Code[20];

    begin
        TestCode := RecCode;
        recPurchLines.SetFilter("Document Type", 'Order');
        recPurchLines.SetFilter("Document No.", DocumentNo);
        IF recPurchLines.FindSet() then
            repeat

                copyRecPurchReqLines.Init();
                copyRecPurchReqLines."Document No." := TestCode;
                copyRecPurchReqLines."Document Type" := copyRecPurchReqLines."Document Type"::Purchase;
                copyRecPurchReqLines.Description := recPurchLines.Description;
                if recPurchLines.Type = recPurchLines.Type::Item then
                    copyRecPurchReqLines.Type := copyRecPurchReqLines.Type::Item
                else
                    copyRecPurchReqLines.Type := copyRecPurchReqLines.Type::" ";
                //copyRecPurchReqLines.Type := recPurchLines.Type;
                copyRecPurchReqLines."Unit Of Measure Code" := recPurchLines."Unit Of Measure Code";
                /*  copyRecPurchReqLines."Vendor No." := recPurchLines."Vendor No.";
                 copyRecPurchReqLines."Vendor Name" := recPurchLines."Vendor Name"; */
                copyRecPurchReqLines.Amount := recPurchLines.Amount;
                copyRecPurchReqLines."Line No." := recPurchLines."Line No.";
                copyRecPurchReqLines."No." := recPurchLines."No.";
                copyRecPurchReqLines.Quantity := recPurchLines.Quantity;
                copyRecPurchReqLines."Unit Cost" := recPurchLines."Unit Cost";
                copyRecPurchReqLines.Location := recPurchLines."Location Code";
                copyRecPurchReqLines.Insert();


            until recPurchLines.Next() = 0;


    END;

}