codeunit 50151 "Purchase Req. Mgmt._IXO"
{
    trigger OnRun()
    var

    begin

    end;

    procedure CreateApprovalEntries(DocType: Enum "Purch. Req. Doc Type"; DocNo: Code[20]; PurchaserCode: Code[20]; SeqNo: Integer; ReqAmount: Decimal; ApproverID: Code[20]; RECIDtoApprove: RecordId; WrkflwUserGrp: Code[20])
    var
        ReqApprovalEntries: Record "Req. Approval Entries_IXO";
        Cont2: Record "Purchase Req. Header_IXO";

    begin
        // with ReqApprovalEntries do begin
        ReqApprovalEntries.Init();
        ReqApprovalEntries."Table ID" := 90002;
        ReqApprovalEntries."Document Type" := DocType;
        ReqApprovalEntries."Document No." := DocNo;
        ReqApprovalEntries."Salespers./Purch. Code" := PurchaserCode;
        ReqApprovalEntries."Sequence No." := SeqNo;
        // Evaluate("Sender ID", UserId());
        ReqApprovalEntries."Sender ID" := format(USERID());
        ReqApprovalEntries.Amount := ReqAmount;
        ReqApprovalEntries."Amount (LCY)" := ReqAmount;
        ReqApprovalEntries."Approver ID" := ApproverID;
        ReqApprovalEntries."Approval Code" := WrkflwUserGrp;
        ReqApprovalEntries."Workflow Step Instance ID" := '00000000-0000-0000-0000-000000000000';
        IF ApproverId = USERID() THEN begin
            ReqApprovalEntries.Status := ReqApprovalEntries.Status::Approved;
            Cont2.SetFilter("Document No.", DocNo);
            Cont2.SetRange("Document Type", DocType);
            IF Cont2.FindFirst() then begin
                Cont2.Status := Cont2.Status::Approved;
                Cont2.Modify();
            end;
        end
        ELSE
            IF ReqApprovalEntries."Sequence No." = 1 THEN
                ReqApprovalEntries.Status := ReqApprovalEntries.Status::Open
            // Go find the DocNo in Header and change it to Approved.


            ELSE
                ReqApprovalEntries.Status := ReqApprovalEntries.Status::Created;
        ReqApprovalEntries."Date-Time Sent for Approval" := CREATEDATETIME(TODAY(), TIME());
        ReqApprovalEntries."Last Date-Time Modified" := CREATEDATETIME(TODAY(), TIME());
        // "Last Modified By User ID" := Evaluate("Last Date-Time Modified", UserId());

        ReqApprovalEntries."Last Modified By User ID" := Format(USERID());
        ReqApprovalEntries."Due Date" := TODAY();
        ReqApprovalEntries."Available Credit Limit (LCY)" := 0;
        ReqApprovalEntries."Record ID to Approve" := RECIDtoApprove;
        ReqApprovalEntries.INSERT(TRUE);
        //end;

    end;

    procedure MakePurchaseDocument(IncomingLine: Record "Purchase Requisition Line_IXO")
    var
        POHeader: Record "Purchase Header";
        POLine: Record "Purchase Line";
    begin
        //with POHeader do begin
        POHeader.init();
        POHeader."Document Type" := POHeader."Document Type"::Order;
        POHeader.Validate(POHeader."Buy-from Vendor No.", IncomingLine."Vendor No.");
        //   Validate("Posting Date", IncomingLine."Posting Date");
        POHeader.Insert(true);
        POLine.Init();
        POLine."Document Type" := POLine."Document Type"::Order;
        POLine."Document No." := POHeader."No.";
        POLine."Line No." := 10000;
        poline.Validate("Buy-from Vendor No.", POHeader."Buy-from Vendor No.");
        IF IncomingLine.Type = IncomingLine.Type::Item then
            POLine.Type := POLine.Type::Item;
        POLine.Validate(POLine."No.", IncomingLine."No.");
        POLine.Validate(POLine."Location Code", IncomingLine.Location);
        POLine.Validate(POLine.Quantity, IncomingLine.Quantity);
        POLine.Validate(POLine."Direct Unit Cost", IncomingLine."Unit Cost");
        POLine."Req. Document No._IXO" := IncomingLine."Document No.";
        POLine."Purch. Req. Line No._IXO" := IncomingLine."Line No.";
        POLine.Validate(POLine."Job No.", IncomingLine."Job No.");
        POLine.Validate(POLine."Job Task No.", IncomingLine."Job Task No.");
        POLine.Validate("Shortcut Dimension 1 Code", IncomingLine."Shortcut Dimension 1 Code");
        POLine.Validate("Shortcut Dimension 2 Code", IncomingLine."Shortcut Dimension 2 Code");
        POLine.ValidateShortcutDimCode(3, IncomingLine."Shortcut Dimension 3 Code");
        POLine.ValidateShortcutDimCode(4, IncomingLine."Shortcut Dimension 4 Code");
        POLine.ValidateShortcutDimCode(5, IncomingLine."Shortcut Dimension 5 Code");
        POLine.ValidateShortcutDimCode(6, IncomingLine."Shortcut Dimension 6 Code");
        POLine.ValidateShortcutDimCode(7, IncomingLine."Shortcut Dimension 7 Code");
        POLine.ValidateShortcutDimCode(8, IncomingLine."Shortcut Dimension 8 Code");
        POLine.Insert();




        // END;
        Commit();
        IF Dialog.Confirm('Purchase Order %1 Succesfully Created. \Do you want to Open?', true, POHeader."No.") then
            Page.RunModal(page::"Purchase Order", POHeader);
    end;

    procedure MakePurchaseDocumentIfExists(IncomingLine: Record "Purchase Requisition Line_IXO"; PurchLine: Record "Purchase Line")
    var
        POLine: Record "Purchase Line";
    begin
        POLine.Init();
        POLine."Document Type" := POLine."Document Type"::Order;
        POLine."Document No." := PurchLine."Document No.";
        POLine."Line No." := PurchLine."Line No." + 10000;
        IF IncomingLine.Type = IncomingLine.Type::Item then
            POLine.Type := POLine.Type::Item;
        POLine.Validate(POLine."No.", IncomingLine."No.");
        POLine.Validate(POLine.Quantity, IncomingLine.Quantity);
        POLine.Validate(POLine."Direct Unit Cost", IncomingLine."Unit Cost");
        poline."Req. Document No._IXO" := IncomingLine."Document No.";
        POLine."Purch. Req. Line No._IXO" := IncomingLine."Line No.";
        POLine.Insert();
    END;

    procedure MakeInvoiceDocument(IncomingLine: Record "Purchase Requisition Line_IXO")

    var
        POHeader: Record "Purchase Header";
        POLine: Record "Purchase Line";
    begin

        POHeader.Init();
        POHeader."Document Type" := POHeader."Document Type"::Invoice;
        POHeader.Validate(POHeader."Buy-from Vendor No.", IncomingLine."Vendor No.");
        //  Validate("Posting Date", IncomingLine."Posting Date");
        POHeader.Insert(true);
        POLine.Init();
        POLine."Document Type" := POLine."Document Type"::Invoice;
        POLine."Document No." := POHeader."No.";
        POLine."Line No." := 10000;
        poline.Validate("Buy-from Vendor No.", POHeader."Buy-from Vendor No.");
        IF IncomingLine.Type = IncomingLine.Type::Item then
            POLine.Type := POLine.Type::Item;
        POLine.Validate(POLine."No.", IncomingLine."No.");
        POLine.Validate(POLine.Quantity, IncomingLine.Quantity);
        POLine.Validate(POLine."Direct Unit Cost", IncomingLine."Unit Cost");
        POLine."Req. Document No._IXO" := IncomingLine."Document No.";
        POLine.Validate(POLine."Job No.", IncomingLine."Job No.");
        POLine.Validate(POLine."Job Task No.", IncomingLine."Job Task No.");
        POLine.Validate(POLine."Location Code", IncomingLine.Location);
        POLine."Purch. Req. Line No._IXO" := IncomingLine."Line No.";
        POLine.Validate("Shortcut Dimension 1 Code", IncomingLine."Shortcut Dimension 1 Code");
        POLine.Validate("Shortcut Dimension 2 Code", IncomingLine."Shortcut Dimension 2 Code");
        POLine.ValidateShortcutDimCode(3, IncomingLine."Shortcut Dimension 3 Code");
        POLine.ValidateShortcutDimCode(4, IncomingLine."Shortcut Dimension 4 Code");
        POLine.ValidateShortcutDimCode(5, IncomingLine."Shortcut Dimension 5 Code");
        POLine.ValidateShortcutDimCode(6, IncomingLine."Shortcut Dimension 6 Code");
        POLine.ValidateShortcutDimCode(7, IncomingLine."Shortcut Dimension 7 Code");
        POLine.ValidateShortcutDimCode(8, IncomingLine."Shortcut Dimension 8 Code");
        POLine.Insert();
        //END;
        Commit();
        IF Dialog.Confirm('Purchase Invoice %1 Succesfully Created. \Do you want to Open?', true, POHeader."No.") then
            Page.RunModal(page::"Purchase Invoice", POHeader);
    end;


    procedure MakeInvoiceDocumentIfExists(IncomingLine: Record "Purchase Requisition Line_IXO"; PurchLine: Record "Purchase Line")
    var
        POLine: Record "Purchase Line";
    begin
        POLine.Init();
        POLine."Document Type" := POLine."Document Type"::Invoice;
        POLine."Document No." := PurchLine."Document No.";
        POLine."Line No." := PurchLine."Line No." + 10000;
        IF IncomingLine.Type = IncomingLine.Type::Item then
            POLine.Type := POLine.Type::Item;
        POLine.Validate(POLine."No.", IncomingLine."No.");
        POLine.Validate(POLine.Quantity, IncomingLine.Quantity);
        POLine.Validate(POLine."Direct Unit Cost", IncomingLine."Unit Cost");
        poline."Req. Document No._IXO" := IncomingLine."Document No.";
        POLine."Purch. Req. Line No._IXO" := IncomingLine."Line No.";
        POLine.Validate("Shortcut Dimension 1 Code", IncomingLine."Shortcut Dimension 1 Code");
        POLine.Validate("Shortcut Dimension 2 Code", IncomingLine."Shortcut Dimension 2 Code");
        POLine.ValidateShortcutDimCode(3, IncomingLine."Shortcut Dimension 3 Code");
        POLine.ValidateShortcutDimCode(4, IncomingLine."Shortcut Dimension 4 Code");
        POLine.ValidateShortcutDimCode(5, IncomingLine."Shortcut Dimension 5 Code");
        POLine.ValidateShortcutDimCode(6, IncomingLine."Shortcut Dimension 6 Code");
        POLine.ValidateShortcutDimCode(7, IncomingLine."Shortcut Dimension 7 Code");
        POLine.ValidateShortcutDimCode(8, IncomingLine."Shortcut Dimension 8 Code");
        POLine.Insert();
    END;

    procedure IssueMaterial(IncomingLine: Record "Purchase Requisition Line_IXO")
    var
        recItemJL: Record "Item Journal Line";
        recPurchPayable: Record "Purch. Req. Setup_IXO";
        recBatchTable: Record "Item Journal Batch";
        recNoSeriesTable: Record "No. Series Line";
        recNoSeries: Code[20];
        noSeriestoStart: Code[20];
        noSeriesExists: Boolean;
        //----------for gl entry------------
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLineFindLast: Record "Gen. Journal Line";
        SRGenJnlBatch: Record "Gen. Journal Batch";
        PRSetup: Record "Purch. Req. Setup_IXO";
        NoSeriesLine: Record "No. Series Line";
        DocNoGenJnl: Code[20];
        DocNoGenJnl1: Code[20];
        DocNoGenJnl2: Code[20];
        LineNo: Integer;
    begin
        recPurchPayable.get();

        recBatchTable.SetFilter("Journal Template Name", 'Item');
        recBatchTable.SetFilter(Name, recPurchPayable."Issue Material Batch_IXO");
        IF recBatchTable.FindFirst() then begin
            IF recBatchTable."No. Series" <> '' then
                noSeriesExists := true;

            recNoSeriesTable.Reset();
            recNoSeriesTable.SetFilter("Series Code", recBatchTable."No. Series");
            recNoSeriesTable.SetFilter("Line No.", '10000');

            IF recNoSeriesTable.FindFirst() then
                IF recNoSeriesTable."Last No. Used" = '' then
                    noSeriestoStart := recNoSeriesTable."Starting No."
                else
                    noSeriestoStart := IncStr(recNoSeriesTable."Last No. Used")

            else begin
                recNoSeries := '';
                noSeriesExists := false;
            end;
            recItemJL.SetFilter("Journal Template Name", 'Item');
            recItemJL.SetFilter("Journal Batch Name", recPurchPayable."Issue Material Batch_IXO");
            IF recItemJL.FindLast() then
                recItemJL."Line No." := recItemJL."Line No." + 10000;

        end;
        PRSetup.Get();
        if IncomingLine."Charge to Owner" = false then begin
            if PRSetup."Material Req. G/L Account Cr." <> '' then begin
                if PRSetup."Material Req. G/L Account Dr." <> '' then begin
                    if PRSetup."Material Request Gen. Template" <> '' then begin
                        if PRSetup."Material Request Batch" <> '' then begin
                            recItemJL.Init();
                            recItemJL."Journal Template Name" := 'Item';
                            recItemJL."Journal Batch Name" := recPurchPayable."Issue Material Batch_IXO";
                            recItemJL."Posting Date" := WorkDate();
                            IF noSeriesExists = true then
                                recItemJL."Document No." := noSeriestoStart
                            else
                                recItemJL."Document No." := IncomingLine."Document No.";
                            recItemJL."External Document No." := IncomingLine."Document No." + '-' + format(IncomingLine."Line No."); //Check This
                            recItemJL."Entry Type" := recItemJL."Entry Type"::"Negative Adjmt.";
                            recItemJL.Validate(recItemJL."Item No.", IncomingLine."No.");
                            recItemJL.Validate(recItemJL."Location Code", IncomingLine.Location);
                            recItemJL.Validate(Quantity, IncomingLine.Quantity);
                            recItemJL.Validate("Unit Amount", IncomingLine."Unit Cost");
                            recItemJL.Validate("Unit Cost", IncomingLine."Unit Cost");
                            recItemJL.Validate(Amount, IncomingLine.Amount);
                            recItemJL.Validate("Shortcut Dimension 1 Code", IncomingLine."Shortcut Dimension 1 Code");
                            recItemJL.Validate("Shortcut Dimension 2 Code", IncomingLine."Shortcut Dimension 2 Code");
                            recItemJL.ValidateShortcutDimCode(3, IncomingLine."Shortcut Dimension 3 Code");
                            recItemJL.ValidateShortcutDimCode(4, IncomingLine."Shortcut Dimension 4 Code");
                            recItemJL.ValidateShortcutDimCode(5, IncomingLine."Shortcut Dimension 5 Code");
                            recItemJL.ValidateShortcutDimCode(6, IncomingLine."Shortcut Dimension 6 Code");
                            recItemJL.ValidateShortcutDimCode(7, IncomingLine."Shortcut Dimension 7 Code");
                            recItemJL.ValidateShortcutDimCode(8, IncomingLine."Shortcut Dimension 8 Code");
                            recItemJL.Insert(true);
                            Message('Item No. %1 is succesfully created in Item Journal.', IncomingLine."No.");
                            // end;
                            if recPurchPayable."Post While Issue Material_IXO" = true then
                                Codeunit.Run(Codeunit::"Item Jnl.-Post", recItemJL);
                            //----------------------Item journal code End-----------------------------------
                            //-----------------------Material G/L Entry code Start----------------------
                            if IncomingLine."Service Request No." <> '' then begin //add condition by keyur as suggested by jaydeep for stoping jv creation due to servicr request no.

                                Clear(DocNoGenJnl);
                                Clear(DocNoGenJnl1);
                                Clear(DocNoGenJnl2);

                                PRSetup.Get();

                                GenJnlLineFindLast.SetRange("Journal Template Name", PRSetup."Material Request Gen. Template");
                                GenJnlLineFindLast.SetRange("Journal Batch Name", PRSetup."Material Request Batch");
                                if GenJnlLineFindLast.FindLast() then begin
                                    LineNo := GenJnlLineFindLast."Line No." + 10000;
                                    DocNoGenJnl1 := GenJnlLineFindLast."Document No.";
                                end
                                else
                                    LineNo := 10000;

                                if SRGenJnlBatch.Get(PRSetup."Material Request Gen. Template", PRSetup."Material Request Batch") then begin
                                    NoSeriesLine.Reset();
                                    NoSeriesLine.SetFilter("Series Code", SRGenJnlBatch."No. Series");
                                    if NoSeriesLine.FindLast() then begin
                                        if NoSeriesLine."Last No. Used" <> '' then
                                            DocNoGenJnl2 := IncStr(NoSeriesLine."Last No. Used")
                                        else
                                            DocNoGenJnl2 := NoSeriesLine."Starting No.";
                                    end else
                                        NoSeriesLine.TestField("Series Code");

                                    if DocNoGenJnl1 <> '' then
                                        DocNoGenJnl := IncStr(DocNoGenJnl1)
                                    else
                                        DocNoGenJnl := DocNoGenJnl2;

                                    GenJnlLine.Init();
                                    GenJnlLine.Validate("Journal Template Name", PRSetup."Material Request Gen. Template");
                                    GenJnlLine.Validate("Journal Batch Name", PRSetup."Material Request Batch");
                                    GenJnlLine.Validate("Line No.", LineNo);
                                    GenJnlLine.Validate("Posting Date", Today);
                                    GenJnlLine.Validate("Document No.", DocNoGenJnl);
                                    GenJnlLine.Validate("Document Type", GenJnlLine."Document Type");
                                    // GenJnlLine.Validate("Service Request No.", IncomingLine."Service Request No.");
                                    // GenJnlLine.Validate("Service Request Line No.", IncomingLine."Service Request Line No.");
                                    GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                                    GenJnlLine.Validate("Account No.", PRSetup."Material Req. G/L Account Dr.");
                                    GenJnlLine.Validate("Debit Amount", IncomingLine.Amount);
                                    GenJnlLine.Validate("Shortcut Dimension 1 Code", IncomingLine."Shortcut Dimension 1 Code");
                                    GenJnlLine.Validate("Shortcut Dimension 2 Code", IncomingLine."Shortcut Dimension 2 Code");
                                    GenJnlLine.ValidateShortcutDimCode(3, IncomingLine."Shortcut Dimension 3 Code");
                                    GenJnlLine.ValidateShortcutDimCode(4, IncomingLine."Shortcut Dimension 4 Code");
                                    GenJnlLine.ValidateShortcutDimCode(5, IncomingLine."Shortcut Dimension 5 Code");
                                    GenJnlLine.ValidateShortcutDimCode(6, IncomingLine."Shortcut Dimension 6 Code");
                                    GenJnlLine.ValidateShortcutDimCode(7, IncomingLine."Shortcut Dimension 7 Code");
                                    GenJnlLine.ValidateShortcutDimCode(8, IncomingLine."Shortcut Dimension 8 Code");
                                    GenJnlLine.Insert();
                                    Commit();
                                    GenJnlLine2.Init();
                                    GenJnlLine2.Validate("Journal Template Name", PRSetup."Material Request Gen. Template");
                                    GenJnlLine2.Validate("Journal Batch Name", PRSetup."Material Request Batch");
                                    GenJnlLine2.Validate("Line No.", LineNo + 10000);
                                    GenJnlLine2.Validate("Posting Date", GenJnlLine."Posting Date");
                                    GenJnlLine2.Validate("Document No.", GenJnlLine."Document No.");
                                    // GenJnlLine2.Validate("Service Request No.", IncomingLine."Service Request No.");
                                    // GenJnlLine2.Validate("Service Request Line No.", IncomingLine."Service Request Line No.");
                                    GenJnlLine2.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
                                    GenJnlLine2.Validate("Account No.", PRSetup."Material Req. G/L Account Cr.");
                                    GenJnlLine2.Validate("Credit Amount", IncomingLine."Amount");
                                    GenJnlLine2.Validate("Shortcut Dimension 1 Code", IncomingLine."Shortcut Dimension 1 Code");
                                    GenJnlLine2.Validate("Shortcut Dimension 2 Code", IncomingLine."Shortcut Dimension 2 Code");
                                    GenJnlLine2.ValidateShortcutDimCode(3, IncomingLine."Shortcut Dimension 3 Code");
                                    GenJnlLine2.ValidateShortcutDimCode(4, IncomingLine."Shortcut Dimension 4 Code");
                                    GenJnlLine2.ValidateShortcutDimCode(5, IncomingLine."Shortcut Dimension 5 Code");
                                    GenJnlLine2.ValidateShortcutDimCode(6, IncomingLine."Shortcut Dimension 6 Code");
                                    GenJnlLine2.ValidateShortcutDimCode(7, IncomingLine."Shortcut Dimension 7 Code");
                                    GenJnlLine2.ValidateShortcutDimCode(8, IncomingLine."Shortcut Dimension 8 Code");
                                    GenJnlLine2.Insert();
                                    Commit();
                                    // Message('General Journal Entry Created Successfully');
                                    GenJnlLine.SetRange("Journal Template Name", PRSetup."Material Request Gen. Template");
                                    GenJnlLine.SetRange("Journal Batch Name", PRSetup."Material Request Batch");
                                    IF GenJnlLine.FindFirst() then
                                        IF Dialog.Confirm('General Journal Entry Created Successfully. \Do you want to Open?', true, GenJnlLine."Document No.") then
                                            Page.RunModal(page::"General Journal", GenJnlLine);
                                end;
                            end;
                        end
                        else
                            PRSetup.TestField("Material Request Batch");
                    end
                    else
                        PRSetup.TestField("Material Request Gen. Template");
                end
                else
                    PRSetup.TestField("Material Req. G/L Account Dr.");
            end
            else
                PRSetup.TestField("Material Req. G/L Account Cr.");
        end
        else begin
            recItemJL.Init();

            recItemJL."Journal Template Name" := 'Item';
            recItemJL."Journal Batch Name" := recPurchPayable."Issue Material Batch_IXO";
            recItemJL."Posting Date" := WorkDate();
            IF noSeriesExists = true then
                recItemJL."Document No." := noSeriestoStart
            else
                recItemJL."Document No." := IncomingLine."Document No.";
            recItemJL."External Document No." := IncomingLine."Document No." + '-' + format(IncomingLine."Line No."); //Check This
            recItemJL."Entry Type" := recItemJL."Entry Type"::"Negative Adjmt.";
            recItemJL.Validate(recItemJL."Item No.", IncomingLine."No.");
            recItemJL.Validate(recItemJL."Location Code", IncomingLine.Location);
            recItemJL.Validate(Quantity, IncomingLine.Quantity);
            recItemJL.Validate("Unit Amount", IncomingLine."Unit Cost");
            recItemJL.Validate("Unit Cost", IncomingLine."Unit Cost");
            recItemJL.Validate(Amount, IncomingLine.Amount);
            recItemJL.Validate("Shortcut Dimension 1 Code", IncomingLine."Shortcut Dimension 1 Code");
            recItemJL.Validate("Shortcut Dimension 2 Code", IncomingLine."Shortcut Dimension 2 Code");
            recItemJL.ValidateShortcutDimCode(3, IncomingLine."Shortcut Dimension 3 Code");
            recItemJL.ValidateShortcutDimCode(4, IncomingLine."Shortcut Dimension 4 Code");
            recItemJL.ValidateShortcutDimCode(5, IncomingLine."Shortcut Dimension 5 Code");
            recItemJL.ValidateShortcutDimCode(6, IncomingLine."Shortcut Dimension 6 Code");
            recItemJL.ValidateShortcutDimCode(7, IncomingLine."Shortcut Dimension 7 Code");
            recItemJL.ValidateShortcutDimCode(8, IncomingLine."Shortcut Dimension 8 Code");
            recItemJL.Insert(true);
            Message('Item No. %1 is succesfully created in Item Journal.', IncomingLine."No.");
            // end;
            if recPurchPayable."Post While Issue Material_IXO" = true then
                Codeunit.Run(Codeunit::"Item Jnl.-Post", recItemJL);
        end;

    end;


}