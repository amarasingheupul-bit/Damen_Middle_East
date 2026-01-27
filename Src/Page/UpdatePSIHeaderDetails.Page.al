page 50116 "Update PSI Header Details"
{
    PageType = Card;
    Caption = 'Update PSI Header Related Data';
    ApplicationArea = All;
    UsageCategory = Administration;
    Permissions = tabledata "Sales Invoice Header" = RIM,
                    tabledata "Excel Data Import General" = RIMD;


    actions
    {
        area(Processing)
        {
            action(UpdateData)
            {
                ApplicationArea = All;
                ToolTip = 'Tool Tip';
                Image = Process;

                trigger OnAction()
                begin
                    // this.EntryNo.FindSet();
                    if this.EntryNo.FindFirst() then
                        repeat

                            this.SINVHDR.Reset();
                            this.SINVHDR.SetFilter(this.SINVHDR."No.", '%1', this.EntryNo."Document No.");

                            if this.SINVHDR.FindFirst() then
                                repeat

                                    if this.EntryNo.UpdateField = 'CurFactor' then
                                        this.SINVHDR."Currency Factor" := this.EntryNo."Value 2";
                                    if this.EntryNo.UpdateField = 'SalesManager' then
                                        this.SINVHDR."Sales Manager" := this.EntryNo."Value 3";

                                    this.SINVHDR.Modify();
                                until this.SINVHDR.Next() = 0;

                        until this.EntryNo.Next() = 0;

                    Message('Process Finished');

                end;
            }
        }

    }
    var
        EntryNo: Record "Excel Data Import General";

        SINVHDR: Record "Sales Invoice Header";
}