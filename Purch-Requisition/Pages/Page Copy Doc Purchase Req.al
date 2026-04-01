page 50161 "Copy Purchase Req. Page_IXO"
{
    PageType = StandardDialog;
    Caption = 'Copy Exisiting Purchase Requisition';
    // ApplicationArea = All;
    //  UsageCategory = Administration;
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
                    LookupPageId = "Purchase Requisition List_IXO";

                    TableRelation = "Purchase Req. Header_IXO"."Document No." where("Document Type" = const(Purchase));
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
        recPurchReqLines: Record "Purchase Requisition Line_IXO";
        copyRecPurchReqLines: Record "Purchase Requisition Line_IXO";
        TestCode: Code[20];
    begin
        TestCode := RecCode;
        recPurchReqLines.SetFilter("Document Type", 'Purchase');
        recPurchReqLines.SetFilter("Document No.", DocumentNo);
        IF recPurchReqLines.FindSet() then
            repeat

                copyRecPurchReqLines.Init();
                copyRecPurchReqLines."Document No." := TestCode;
                copyRecPurchReqLines."Document Type" := recPurchReqLines."Document Type"::Purchase;
                copyRecPurchReqLines.Description := recPurchReqLines.Description;
                //copyRecPurchReqLines."Description 2" := recPurchReqLines."Description 2";
                copyRecPurchReqLines.Type := recPurchReqLines.Type;
                copyRecPurchReqLines."Unit Of Measure Code" := recPurchReqLines."Unit Of Measure Code";
                copyRecPurchReqLines."Vendor No." := recPurchReqLines."Vendor No.";
                copyRecPurchReqLines."Vendor Name" := recPurchReqLines."Vendor Name";
                copyRecPurchReqLines.Amount := recPurchReqLines.Amount;
                copyRecPurchReqLines."Line No." := recPurchReqLines."Line No.";
                copyRecPurchReqLines."No." := recPurchReqLines."No.";
                copyRecPurchReqLines.Quantity := recPurchReqLines.Quantity;
                copyRecPurchReqLines."Unit Cost" := recPurchReqLines."Unit Cost";
                copyRecPurchReqLines.Location := recPurchReqLines.Location;
                copyRecPurchReqLines.Insert(true);


            until recPurchReqLines.Next() = 0;


    END;

}