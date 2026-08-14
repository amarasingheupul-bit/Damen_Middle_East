page 50119 "Purch Approval Audit List"
{
    PageType = List;
    SourceTable = "Purch. Approval Audit";
    Caption = 'Purchase Approval Audit';
    ApplicationArea = All;
    UsageCategory = Lists;

    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type") { }
                field("Document No."; "Document No.") { }
                field("Vendor No."; "Vendor No.") { }
                field("Vendor Name"; "Vendor Name") { }
                field("Purchase Officer"; "Purchase Officer") { }
                field("Sendor ID"; "Sender ID") { }
                field("Sent To User"; "Sent To User") { }
                field("Approver 1 Sent DateTime"; "Approver 1 Sent DateTime") { }
                field("Approver Level 1"; "Approver Level 1") { }
                field("Approver 2 Sent DateTime"; "Approver 2 Sent DateTime") { }
                field("Approver Level 2"; "Approver Level 2") { }
                field("Approver1 to Approver2 Duration"; "Approver1 to Approver2 Duration") { }
                field("Sales Secretary"; "Sales Secretary") { }
                field("Area Director"; "Area Director") { }
                field(Amount; Amount) { }
                field("Currency Code"; "Currency Code") { }
                field("Sent DateTime"; "Sent DateTime") { }
                field("Email Approval Status"; "Email Approval Status") { }
                field("Invoice Status"; "Invoice Status") { }
                field("Status Updated At"; "Status Updated At") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // ============================================================
            // BUTTON 1: Delete ALL audit records for selected document
            // ============================================================
            // ============================================================
            // BUTTON 1: Delete ALL audit records in the entire table
            // ============================================================
            action(DeleteAllAuditRecords)
            {
                Caption = 'Delete All Audit Records';
                ToolTip = 'Deletes ALL audit records in the table.';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Audit: Record "Purch. Approval Audit";
                begin
                    if not Confirm('This will DELETE ALL audit records in the table. Continue?', false) then
                        exit;

                    Audit.Reset(); // No filters — targets entire table
                    Audit.DeleteAll(false); // Single SQL delete, no row-by-row triggers

                    CurrPage.Update(false);
                    Message('All audit records have been deleted.');
                end;
            }

            // ============================================================
            // BUTTON 2: Rebuild ALL audit records from Purchase Headers
            // ============================================================
            action(RebuildAllAuditRecords)
            {
                Caption = 'Update All Audit Records';
                ToolTip = 'Rebuilds audit records for ALL purchase documents at once.';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    ApprovalEntry: Record "Approval Entry";
                    NewAudit: Record "Purch. Approval Audit";
                    LastAudit: Record "Purch. Approval Audit";
                    NextEntryNo: Integer;
                    Counter: Integer;
                begin
                    if not Confirm('This will rebuild audit records for ALL purchase documents. Continue?', false) then
                        exit;

                    // Get starting Entry No.
                    LastAudit.Reset();
                    if LastAudit.FindLast() then
                        NextEntryNo := LastAudit."Entry No." + 1
                    else
                        NextEntryNo := 1;

                    Counter := 0;

                    // Loop through ALL Purchase Invoices
                    PurchHeader.Reset();
                    PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Invoice);

                    if not PurchHeader.FindSet() then begin
                        Message('No Purchase Invoices found.');
                        exit;
                    end;

                    repeat
                        // Get Approval Entries for this document
                        ApprovalEntry.Reset();
                        ApprovalEntry.SetRange("Document No.", PurchHeader."No.");
                        ApprovalEntry.SetRange("Table ID", Database::"Purchase Header");

                        if ApprovalEntry.FindSet() then begin
                            NewAudit.Init();
                            NewAudit."Entry No." := NextEntryNo;
                            NewAudit."Document Type" := PurchHeader."Document Type";
                            NewAudit."Document No." := PurchHeader."No.";
                            NewAudit."Vendor No." := PurchHeader."Buy-from Vendor No.";
                            NewAudit."Vendor Name" := PurchHeader."Buy-from Vendor Name";
                            NewAudit."Purchase Officer" := PurchHeader."Purchaser Code";
                            NewAudit."Sender ID" := ApprovalEntry."Sender ID";
                            NewAudit."Sent To User" := ApprovalEntry."Approver ID";
                            NewAudit."Sent DateTime" := CurrentDateTime;
                            NewAudit."Email Approval Status" := PurchHeader."Email Approval Status";
                            NewAudit."Invoice Status" := PurchHeader.Status;
                            NewAudit."Sales Secretary" := PurchHeader."Sales Secretary Name";
                            NewAudit."Area Director" := PurchHeader."Sales/ Area Director Name";
                            PurchHeader.CalcFields(Amount);
                            NewAudit.Amount := PurchHeader.Amount;
                            NewAudit."Currency Code" := PurchHeader."Currency Code";
                            NewAudit."Status Updated At" := CurrentDateTime;

                            // Approver 1
                            NewAudit."Approver Level 1" := ApprovalEntry."Approver ID";
                            NewAudit."Approver 1 Sent DateTime" := CurrentDateTime;

                            // Approver 2 (if exists)
                            if ApprovalEntry.Next() <> 0 then begin
                                NewAudit."Approver Level 2" := ApprovalEntry."Approver ID";
                                NewAudit."Approver 2 Sent DateTime" := CurrentDateTime;
                                NewAudit."Approver1 to Approver2 Duration" :=
                                    NewAudit."Approver 2 Sent DateTime" - NewAudit."Approver 1 Sent DateTime";
                            end;

                            NewAudit.Insert(false); // false = skip triggers for speed

                            NextEntryNo += 1;
                            Counter += 1;
                        end;

                    until PurchHeader.Next() = 0;

                    CurrPage.Update(false);
                    Message('%1 audit records have been created successfully.', Counter);
                end;
            }
        }
    }
}