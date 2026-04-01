#pragma implicitwith disable
page 50158 "Approved Material Reqs._IXO"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Approved Material Requisitions';
    UsageCategory = Lists;
    SourceTableView = where("Document Type" = filter(Material), Status = filter(Approved | "Partially Processed"), "Partially Processed" = const(0));
    SourceTable = "Purchase Requisition Line_IXO";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
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
                    //  TableRelation = Location;
                    trigger OnValidate()
                    var
                        sinlgeInstance_cu: Codeunit "Single Instance IXO";
                    begin
                        //CurrPage.SaveRecord();
                        // FromApprovedPage();
                        sinlgeInstance_cu.FromApprovedPageTrue();
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Of Measure Code"; Rec."Unit Of Measure Code")
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Service Request No."; Rec."Service Request No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                /*  field("Vendor No."; "Vendor No.")
                 {
                     ApplicationArea = All;
                     Editable = true;
                     TableRelation = Vendor;
                 }
                 field("Vendor Name"; "Vendor Name")
                 {
                     ApplicationArea = All;
                     Editable = true;
                     TableRelation = Vendor;
                 } */
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

                field("Service Request Line No."; Rec."Service Request Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Charge to Owner"; Rec."Charge to Owner")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Issue Material")
            {
                ApplicationArea = All;
                Image = Journal;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    recSetup: Record "Purch. Req. Setup_IXO";
                    PRline: Record "Purchase Requisition Line_IXO";
                    recPRline: Record "Purchase Requisition Line_IXO";
                    PRHeader: Record "Purchase Req. Header_IXO";
                    codeunitPurchReqMgmt: Codeunit "Purchase Req. Mgmt._IXO";
                    totalcount: Integer;
                    cont: Integer;


                begin
                    recSetup.Get();
                    if recSetup."Location Validation_IXO" = true then
                        Rec.TestField(Location);


                    CurrPage.SetSelectionFilter(PRline);
                    //PRHeader.SetRange("Document Type", Rec."Document Type");
                    //  PRHeader.SetRange("Document No.", Rec."Document No.");

                    /*    recPRline.SetRange("Document Type", Rec."Document Type");
                       recPRline.SetRange("Document No.", Rec."Document No.");
                       if recPRline.FindFirst() THEN
                           IF recPRline."Partially Processed" = 1 then
                               Error('Action not allowed. Line is already Processed.'); */

                    IF PRline.FindSet() then
                        repeat
                            codeunitPurchReqMgmt.IssueMaterial(PRline);
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
                        PRHeader.SetFilter("Document Type", 'Material');
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
            }

            action("Make Purchase Requisitions")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Purchase Requisition Card_SR";
                RunPageLink = "Document Type" = filter(Purchase);
                RunPageMode = Create;
                Image = TaskPage;

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
