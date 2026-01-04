#pragma warning disable AA0215
page 50112 "Update PSI Fields"
#pragma warning restore AA0215
{
    PageType = Card;
    Caption = 'Update PSI Related Data';
    ApplicationArea = All;
    UsageCategory = Administration;
    Permissions = tabledata "G/L Entry" = RMID,
                    tabledata "Sales Invoice Header" = RIMD,
                    tabledata "Cust. Ledger Entry" = RIMD,
                    tabledata "Detailed Cust. Ledg. Entry" = RIMD,
                    tabledata "VAT Entry" = RIMD;

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
                            this.GL.Reset();
                            this.GL.SetFilter("Document No.", '%1', this.EntryNo."Document No.");

                            if this.GL.FindFirst() then
                                repeat
                                    if this.GL.Amount > 0 then begin
                                        this.GL.Amount := this.EntryNo."Value 2";
                                        this.GL."Debit Amount" := this.EntryNo."Value 2"
                                    end;
                                    if this.GL.Amount < 0 then begin
                                        this.GL.Amount := this.EntryNo."Value 2" * -1;
                                        this.GL."Credit Amount" := this.EntryNo."Value 2";
                                    end;

                                    this.GL.Modify();
                                until this.GL.Next() = 0;


                            this.VATE.Reset();
                            this.VATE.SetFilter("Document No.", '%1', this.EntryNo."Document No.");

                            if this.VATE.FindFirst() then
                                repeat
                                    if this.VATE.Base > 0 then begin
                                        this.VATE.Base := this.EntryNo."Value 2";
                                        this.VATE."Base Before Pmt. Disc." := this.EntryNo."Value 2";
                                    end;
                                    if this.VATE.Base < 0 then begin
                                        this.VATE.Base := this.EntryNo."Value 2" * -1;
                                        this.VATE."Base Before Pmt. Disc." := this.EntryNo."Value 2" * -1;
                                    end;

                                    this.VATE.Modify();
                                until this.VATE.Next() = 0;


                            this.CLE.Reset();
                            this.CLE.SetFilter("Document No.", '%1', this.EntryNo."Document No.");

                            if this.CLE.FindFirst() then
                                repeat

                                    this.CLE."Original Amt. (LCY)" := this.EntryNo."Value 2";
                                    this.CLE."Amount (LCY)" := this.EntryNo."Value 2";
                                    this.CLE."Sales (LCY)" := this.EntryNo."Value 2";
                                    this.CLE."Profit (LCY)" := this.EntryNo."Value 2";
                                    this.CLE."Debit Amount (LCY)" := this.EntryNo."Value 2";
                                    this.CLE."Original Currency Factor" := this.EntryNo."Value 1";
                                    this.CLE."Adjusted Currency Factor" := this.EntryNo."Value 1";

                                    this.CLE.Modify();
                                until this.CLE.Next() = 0;


                            this.DCLE.Reset();
                            this.DCLE.SetFilter("Document No.", '%1', this.EntryNo."Document No.");

                            if this.DCLE.FindFirst() then
                                repeat

                                    this.DCLE."Amount (LCY)" := this.EntryNo."Value 2";
                                    this.DCLE."Debit Amount (LCY)" := this.EntryNo."Value 2";

                                    this.DCLE.Modify();
                                until this.DCLE.Next() = 0;



                            this.SINVHDR.Reset();
                            this.SINVHDR.SetFilter(SINVHDR."No.", '%1', this.EntryNo."Document No.");

                            if this.SINVHDR.FindFirst() then
                                repeat

                                    this.SINVHDR."Currency Factor" := this.EntryNo."Value 1";

                                    this.SINVHDR.Modify();
                                until this.SINVHDR.Next() = 0;



                        until this.EntryNo.Next() = 0;

                    Message('Process Finished');

                end;
            }
        }

    }
    var
        EntryNo: Record "Excel Data Import";
        GL: Record "G/L Entry";
        CLE: Record "Cust. Ledger Entry";
        DCLE: Record "Detailed Cust. Ledg. Entry";
        SINVHDR: Record "Sales Invoice Header";
        VATE: Record "VAT Entry";

}