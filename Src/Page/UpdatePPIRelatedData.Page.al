#pragma warning disable AA0215
page 50113 "Update PPI Fields"
#pragma warning restore AA0215

{
    PageType = Card;
    Caption = 'Update PPI Related Data';
    ApplicationArea = All;
    UsageCategory = Administration;
    Permissions = tabledata "G/L Entry" = RMID,
                    tabledata "Purch. Inv. Header" = RIMD,
                    tabledata "Vendor Ledger Entry" = RIMD,
                    tabledata "Detailed Vendor Ledg. Entry" = RIMD,
                    tabledata "VAT Entry" = RIMD,
                    tabledata "Item Ledger Entry" = RIMD,
                    tabledata "Value Entry" = RIMD;

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
                            this.GL.SetFilter(this.GL."Document No.", '%1', this.EntryNo."Document No.");

                            if this.GL.FindFirst() then
                                repeat
                                    if this.GL.Amount > 0 then begin
                                        this.GL.Amount := this.EntryNo."Value 2" * -1;
                                        this.GL."Debit Amount" := this.EntryNo."Value 2" * -1;
                                    end;
                                    if this.GL.Amount < 0 then begin
                                        this.GL.Amount := this.EntryNo."Value 2";
                                        this.GL."Credit Amount" := this.EntryNo."Value 2" * -1;
                                    end;

                                    this.GL.Modify();
                                until this.GL.Next() = 0;


                            this.VATE.Reset();
                            this.VATE.SetFilter(this.VATE."Document No.", '%1', this.EntryNo."Document No.");

                            if this.VATE.FindFirst() then
                                repeat
                                    if this.VATE.Base > 0 then begin
                                        this.VATE.Base := this.EntryNo."Value 2" * -1;
                                        this.VATE."Base Before Pmt. Disc." := this.EntryNo."Value 2" * -1;
                                    end;
                                    if this.VATE.Base < 0 then begin
                                        this.VATE.Base := this.EntryNo."Value 2";
                                        this.VATE."Base Before Pmt. Disc." := this.EntryNo."Value 2";
                                    end;

                                    this.VATE.Modify();
                                until this.VATE.Next() = 0;


                            this.VLE.Reset();
                            this.VLE.SetFilter(this.VLE."Document No.", '%1', this.EntryNo."Document No.");

                            if this.VLE.FindFirst() then
                                repeat

                                    this.VLE."Original Amt. (LCY)" := this.EntryNo."Value 2";
                                    this.VLE."Amount (LCY)" := this.EntryNo."Value 2";
                                    this.VLE."Purchase (LCY)" := this.EntryNo."Value 2";
                                    this.VLE."Debit Amount (LCY)" := this.EntryNo."Value 2";
                                    this.VLE."Original Currency Factor" := this.EntryNo."Value 1";
                                    this.VLE."Adjusted Currency Factor" := this.EntryNo."Value 1";

                                    this.VLE.Modify();
                                until this.VLE.Next() = 0;


                            this.DVLE.Reset();
                            this.DVLE.SetFilter(this.DVLE."Document No.", '%1', this.EntryNo."Document No.");

                            if this.DVLE.FindFirst() then
                                repeat

                                    this.DVLE."Amount (LCY)" := this.EntryNo."Value 2";
                                    this.DVLE."Debit Amount (LCY)" := this.EntryNo."Value 2";

                                    this.DVLE.Modify();
                                until this.DVLE.Next() = 0;


                            this.ILE.Reset();
                            this.ILE.SETRANGE(this.ILE."Entry Type", this.ILE."Entry Type"::Purchase);
                            this.ILE.SetFilter(this.ILE."Document No.", '%1', this.EntryNo."Document No.");

                            if this.ILE.FindFirst() then
                                repeat

                                    this.ILE."Cost Amount (Actual)" := this.EntryNo."Value 2";
                                    this.ILE."Purchase Amount (Actual)" := this.EntryNo."Value 2";

                                    this.ILE.Modify();
                                until this.ILE.Next() = 0;


                            this.VALE.Reset();
                            this.VALE.SETRANGE(this.VALE."Item Ledger Entry Type", this.VALE."Item Ledger Entry Type"::Purchase);
                            this.VALE.SetFilter(this.VALE."Document No.", '%1', this.EntryNo."Document No.");


                            if this.VALE.FindFirst() then
                                repeat

                                    this.VALE."Cost Amount (Actual)" := this.EntryNo."Value 2" * -1;
                                    this.VALE."Purchase Amount (Actual)" := this.EntryNo."Value 2" * -1;

                                    this.VALE.Modify();
                                until this.VALE.Next() = 0;




                            this.PINVHDR.Reset();
                            this.PINVHDR.SetFilter(this.PINVHDR."No.", '%1', this.EntryNo."Document No.");

                            if this.PINVHDR.FindFirst() then
                                repeat

                                    this.PINVHDR."Currency Factor" := this.EntryNo."Value 1";

                                    this.PINVHDR.Modify();
                                until this.PINVHDR.Next() = 0;

                        until this.EntryNo.Next() = 0;

                    Message('Process Finished');

                end;
            }
        }

    }
    var
        EntryNo: Record "Excel Data Import";
        GL: Record "G/L Entry";
        VLE: Record "Vendor Ledger Entry";
        DVLE: Record "Detailed Vendor Ledg. Entry";
        PINVHDR: Record "Purch. Inv. Header";
        VATE: Record "VAT Entry";
        ILE: Record "Item Ledger Entry";
        VALE: Record "Value Entry";

}