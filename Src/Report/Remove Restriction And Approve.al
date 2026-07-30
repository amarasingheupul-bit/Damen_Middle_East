report 50120 "Remove Restriction And Approve"
{
    Caption = 'Remove Restriction And Approve';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Permissions = tabledata "Approval Entry" = RIMD;
    dataset
    {
        dataitem(ApprovalEntry; "Approval Entry")
        {
            DataItemTableView = sorting("Entry No.")
                               where(Status = const(Open));

            trigger OnAfterGetRecord()
            begin
                if ApprovalEntry."Document No." <> DocumentNo then
                    exit;

                // Step 1 - Approve the open entry
                ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                ApprovalEntry."Last Date-Time Modified" := CurrentDateTime();
                ApprovalEntry."Last Modified By User ID" := UserId();
                ApprovalEntry.Modify(true);
                ApprovedCount += 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DocNoField; DocumentNo)
                    {
                        Caption = 'Document No.';
                        ApplicationArea = All;
                        ToolTip = 'Enter Purchase Invoice No., e.g. PI-0449';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    var
        PurchaseHeader: Record "Purchase Header";
        RestrictedRecord: Record "Restricted Record";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if ApprovedCount = 0 then begin
            Message('No Open approval entries found for %1.', DocumentNo);
            exit;
        end;

        // Step 2 - Find the Purchase Invoice header
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);
        PurchaseHeader.SetRange("No.", DocumentNo);
        if not PurchaseHeader.FindFirst() then begin
            Message('Purchase Invoice %1 not found.', DocumentNo);
            exit;
        end;

        // Step 3 - Remove the workflow restriction record
        RestrictedRecord.SetRange("Record ID", PurchaseHeader.RecordId());
        if RestrictedRecord.FindFirst() then
            RestrictedRecord.Delete(true);

        // Step 4 - Update document status to Released
        PurchaseHeader.Status := PurchaseHeader.Status::Released;
        PurchaseHeader.Modify(true);

        Message('%1 entry(ies) approved and restriction removed for %2. Document is now Released.',
                 ApprovedCount, DocumentNo);
    end;

    var
        DocumentNo: Code[20];
        ApprovedCount: Integer;
}