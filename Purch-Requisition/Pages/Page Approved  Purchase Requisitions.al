#pragma implicitwith disable
page 50157 "Approved Purchase Reqs._IXO"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Approved Purchase Requisitions';
    SourceTableView = where("Document Type" = filter(Purchase), Status = filter(Approved | "Partially Processed"), "Partially Processed" = const(0));
    SourceTable = "Purchase Requisition Line_IXO";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater("Approved Purchase Requisitions")
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    Editable = true;
                    //TableRelation = Location;

                    trigger OnValidate()
                    var
                        sinlgeInstance_cu: Codeunit "Single Instance IXO";
                    begin
                        //CurrPage.SaveRecord();
                        // FromReleasedPage();
                        sinlgeInstance_cu.FromApprovedPageTrue();
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                    //  TableRelation = Vendor;

                    trigger OnValidate()
                    var
                        sinlgeInstance_cu: Codeunit "Single Instance IXO";
                    begin
                        //CurrPage.SaveRecord();
                        // FromReleasedPage();
                        sinlgeInstance_cu.FromApprovedPageTrue();
                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,1';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
                    Visible = visibleShortcutDimension1;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,2';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
                    Visible = visibleShortcutDimension2;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
                    Visible = visibleShortcutDimension3;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
                    Visible = visibleShortcutDimension4;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
                    Visible = visibleShortcutDimension5;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
                    Visible = visibleShortcutDimension6;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7));
                    Visible = visibleShortcutDimension7;
                    //Editable = NotEditable;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
                    Visible = visibleShortcutDimension8;
                    //Editable = NotEditable;
                }
                /*  field("Vendor Name"; "Vendor Name")
                 {
                     ApplicationArea = All;
                     Editable = true;
                     TableRelation = Vendor;
                 } */
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Make Order")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Image = MakeOrder;
                ToolTip = 'Convert the Purchase Requisition to Purchase Order';
                trigger OnAction()
                var
                    recSetup: Record "Purch. Req. Setup_IXO";

                    PRline: Record "Purchase Requisition Line_IXO";
                    recPRline: Record "Purchase Requisition Line_IXO";
                    PRHeader: Record "Purchase Req. Header_IXO";
                    MakeOrderCodeunit: Codeunit "Purchase Req. Mgmt._IXO";
                    totalcount: Integer;
                    cont: Integer;

                begin
                    recSetup.Get();
                    if recSetup."Location Validation_IXO" = true then
                        Rec.TestField(Location);

                    Rec.TestField("Vendor No.");
                    IF Confirm('Are you sure you want to Create a New Purchase Order. \Note: If you want to update an existing Purchase Order then press ''No'' Button and Use ''Update Existing Order Button''', true) THEN begin
                        CurrPage.SetSelectionFilter(PRline);
                        if PRline.FindSet() then begin

                            repeat
                                //  PRline.CalcFields("Vendor No.");
                                //    PRline.CalcFields("Posting Date");

                                MakeOrderCodeunit.MakePurchaseDocument(PRline)
                            until PRline.Next() = 0;

                            if PRline.FindFirst() THEN BEGIN
                                PRline."Partially Processed" := 1;
                                PRline.Modify();
                            END;
                            recPRline.Reset();
                            recPRline.SetFilter("Document No.", PRline."Document No.");
                            if recPRline.FindSet() then
                                totalcount := recPRline.Count();
                            repeat
                                cont += recPRline."Partially Processed";
                            until recPRline.Next() = 0;
                            IF totalcount = cont then begin
                                PRHeader.Reset();
                                PRHeader.SetFilter("Document Type", 'Purchase');
                                PRHeader.SetFilter("Document No.", PRline."Document No.");
                                IF PRHeader.FindFirst() then begin
                                    PRHeader.Status := PRHeader.Status::Processed;
                                    PRHeader.Modify();
                                end;
                            end;
                            if cont < totalcount then begin
                                PRHeader.Reset();
                                PRHeader.SetFilter("Document No.", PRline."Document No.");
                                IF PRHeader.FindFirst() then begin
                                    PRHeader.Status := PRHeader.Status::"Partially Processed";
                                    PRHeader.Modify();
                                end;
                            end;

                        end;
                    END
                    ELSE
                        EXIT;

                end;
            }
            action("Update Existing Order")
            {
                ApplicationArea = All;
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PurchaseHdr: Record "Purchase Header";
                    PRHeader: Record "Purchase Req. Header_IXO";
                    recPRline: Record "Purchase Requisition Line_IXO";
                    PRline: Record "Purchase Requisition Line_IXO";
                    updateexisting: page "Update Purchase Document_IXO";
                    totalcount: Integer;
                    cont: Integer;
                begin
                    PurchaseHdr.reset();
                    PurchaseHdr.SetFilter("Document Type", 'Order');
                    PurchaseHdr.setrange("Buy-from Vendor No.", Rec."Vendor No.");
                    if Page.Runmodal(0, PurchaseHdr) = Action::LookupOK then begin
                        //enter your code after clicking OK button
                        updateexisting."Update Order Lines"(Rec, PurchaseHdr."No.");
                        /*   IF updateexisting.RunModal() = Action::OK THEN
                              updateexisting."Update Order Lines"(Rec); */
                        CurrPage.SetSelectionFilter(PRline);
                        if PRline.FindFirst() THEN BEGIN
                            PRline."Partially Processed" := 1;
                            PRline.Modify();
                        END;
                        recPRline.Reset();
                        recPRline.SetFilter("Document No.", PRline."Document No.");
                        if recPRline.FindSet() then
                            totalcount := recPRline.Count();
                        repeat
                            cont += recPRline."Partially Processed";
                        until recPRline.Next() = 0;
                        IF totalcount = cont then begin
                            PRHeader.Reset();
                            PRHeader.SetFilter("Document Type", 'Purchase');
                            PRHeader.SetFilter("Document No.", PRline."Document No.");
                            IF PRHeader.FindFirst() then begin
                                PRHeader.Status := PRHeader.Status::Processed;
                                PRHeader.Modify();
                            end;
                        end;
                        if cont < totalcount then begin
                            PRHeader.Reset();
                            PRHeader.SetFilter("Document No.", PRline."Document No.");
                            IF PRHeader.FindFirst() then begin
                                PRHeader.Status := PRHeader.Status::"Partially Processed";
                                PRHeader.Modify();
                            end;
                        end;
                    end;
                end;
            }

            action("Update Existing Invoice")
            {
                Visible = false;
                ApplicationArea = All;
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PRline: Record "Purchase Requisition Line_IXO";
                    recPRline: Record "Purchase Requisition Line_IXO";
                    PRHeader: Record "Purchase Req. Header_IXO";
                    PurchaseHdr: Record "Purchase Header";
                    updateexisting: page "Update Purchase Invoice_IXO";

                    totalcount: Integer;


                    cont: Integer;


                begin
                    PurchaseHdr.reset();
                    PurchaseHdr.SetFilter("Document Type", 'Invoice');
                    PurchaseHdr.setrange("Buy-from Vendor No.", Rec."Vendor No.");
                    if Page.Runmodal(0, PurchaseHdr) = Action::LookupOK then begin
                        //enter your code after clicking OK button

                        updateexisting."Update Invoice Lines"(Rec, PurchaseHdr."No.");
                        /*   IF updateexisting.RunModal() = Action::OK THEN
                              updateexisting."Update Invoice Lines"(Rec); */
                        CurrPage.SetSelectionFilter(PRline);
                        if PRline.FindFirst() THEN BEGIN
                            PRline."Partially Processed" := 1;
                            PRline.Modify();
                        END;
                        recPRline.Reset();
                        recPRline.SetFilter("Document No.", PRline."Document No.");
                        if recPRline.FindSet() then
                            totalcount := recPRline.Count();
                        repeat
                            cont += recPRline."Partially Processed";
                        until recPRline.Next() = 0;
                        IF totalcount = cont then begin
                            PRHeader.Reset();
                            PRHeader.SetFilter("Document Type", 'Purchase');
                            PRHeader.SetFilter("Document No.", PRline."Document No.");
                            IF PRHeader.FindFirst() then begin
                                PRHeader.Status := PRHeader.Status::Processed;
                                PRHeader.Modify();
                            end;
                        end;
                        if cont < totalcount then begin
                            PRHeader.Reset();
                            PRHeader.SetFilter("Document No.", PRline."Document No.");
                            IF PRHeader.FindFirst() then begin
                                PRHeader.Status := PRHeader.Status::"Partially Processed";
                                PRHeader.Modify();
                            end;
                        end;
                    end;
                end;
            }

            action("Make Invoice")
            {
                Visible = false;
                ApplicationArea = All;
                Image = MakeOrder;
                ToolTip = 'Convert the Purchase Requisition to Purchase Invoice';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                    PurchLine: Record "Purchase Line";
                    recPRline: Record "Purchase Requisition Line_IXO";
                    PRHeader: Record "Purchase Req. Header_IXO";
                    recSetup: Record "Purch. Req. Setup_IXO";
                    PRline: Record "Purchase Requisition Line_IXO";
                    MakeOrderCodeunit: Codeunit "Purchase Req. Mgmt._IXO";
                    totalcount: Integer;
                    cont: Integer;


                begin
                    recSetup.Get();
                    if recSetup."Location Validation_IXO" = true then
                        Rec.TestField(Location);

                    Rec.TestField("Vendor No.");


                    IF Confirm('Are you sure you want to Create a New Purchase Invoice. \Note: If you want to update an existing Purchase Invoice then press ''No'' Button and Use ''Update Existing Invoice'' Button', true) THEN begin
                        CurrPage.SetSelectionFilter(PRline);
                        if PRline.FindSet() then begin
                            repeat

                                PurchLine.Reset();
                                PurchLine.SetRange("Req. Document No._IXO", PRline."Document No.");
                                PurchLine.SetRange("Document Type", PurchLine."Document Type"::Invoice);
                                IF PurchLine.FindLast() then
                                    MakeOrderCodeunit.MakeInvoiceDocumentIfExists(PRline, PurchLine)
                                else
                                    MakeOrderCodeunit.MakeInvoiceDocument(PRline)
                            until PRline.Next() = 0;
                            //Message('The Purchase Invoice has been successfully created.');
                            if PRline.FindFirst() THEN BEGIN
                                PRline."Partially Processed" := 1;
                                PRline.Modify();
                            END;
                            recPRline.Reset();
                            recPRline.SetFilter("Document No.", PRline."Document No.");
                            if recPRline.FindSet() then
                                totalcount := recPRline.Count();
                            repeat
                                cont += recPRline."Partially Processed";
                            until recPRline.Next() = 0;
                            IF totalcount = cont then begin
                                PRHeader.Reset();
                                PRHeader.SetFilter("Document Type", 'Purchase');
                                PRHeader.SetFilter("Document No.", PRline."Document No.");
                                IF PRHeader.FindFirst() then begin
                                    PRHeader.Status := PRHeader.Status::Processed;
                                    PRHeader.Modify();
                                end;
                            end;
                            if cont < totalcount then begin
                                PRHeader.Reset();
                                PRHeader.SetFilter("Document No.", PRline."Document No.");
                                IF PRHeader.FindFirst() then begin
                                    PRHeader.Status := PRHeader.Status::"Partially Processed";
                                    PRHeader.Modify();
                                end;
                            end;

                        end;
                    END
                    ELSE
                        exit;
                end;
            }

        }
    }

    var
        visibleShortcutDimension1: Boolean;
        visibleShortcutDimension2: Boolean;
        visibleShortcutDimension3: Boolean;
        visibleShortcutDimension4: Boolean;
        visibleShortcutDimension5: Boolean;
        visibleShortcutDimension6: Boolean;
        visibleShortcutDimension7: Boolean;
        visibleShortcutDimension8: Boolean;

    trigger OnOpenPage()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();

        if GLSetup."Shortcut Dimension 7 Code" = '' then
            visibleShortcutDimension7 := false
        else
            visibleShortcutDimension7 := true;
        if GLSetup."Shortcut Dimension 1 Code" = '' then
            visibleShortcutDimension1 := false
        else
            visibleShortcutDimension1 := true;
        if GLSetup."Shortcut Dimension 2 Code" = '' then
            visibleShortcutDimension2 := false
        else
            visibleShortcutDimension2 := true;
        if GLSetup."Shortcut Dimension 3 Code" = '' then
            visibleShortcutDimension3 := false
        else
            visibleShortcutDimension3 := true;
        if GLSetup."Shortcut Dimension 4 Code" = '' then
            visibleShortcutDimension4 := false
        else
            visibleShortcutDimension4 := true;
        if GLSetup."Shortcut Dimension 5 Code" = '' then
            visibleShortcutDimension5 := false
        else
            visibleShortcutDimension5 := true;
        if GLSetup."Shortcut Dimension 6 Code" = '' then
            visibleShortcutDimension6 := false
        else
            visibleShortcutDimension6 := true;
        if GLSetup."Shortcut Dimension 8 Code" = '' then
            visibleShortcutDimension8 := false
        else
            visibleShortcutDimension8 := true;


    end;


}
#pragma implicitwith restore
