report 50119 "Force Approve Open Entries"
{
    Caption = 'Force Approve Open Entries';
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
                // Only process Open entries for the entered Document No.
                if ApprovalEntry."Document No." = DocumentNo then begin
                    ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                    ApprovalEntry."Last Date-Time Modified" := CurrentDateTime();
                    ApprovalEntry."Last Modified By User ID" := UserId();
                    ApprovalEntry.Modify(true);
                    ApprovedCount += 1;
                end;
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
                    Caption = 'Filter';
                    field(DocumentNoField; DocumentNo)
                    {
                        Caption = 'Document No.';
                        ApplicationArea = All;
                        ToolTip = 'Enter the Sales Order or Document No. to approve.';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        if ApprovedCount = 0 then
            Message('No Open approval entries found for Document No. %1.', DocumentNo)
        else
            Message('%1 approval entry(ies) approved successfully for Document No. %2.',
                     ApprovedCount, DocumentNo);
    end;

    var
        DocumentNo: Code[20];
        ApprovedCount: Integer;
}