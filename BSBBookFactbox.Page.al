page 50102 "BSB Book Factbox"
{
    Caption = 'Book Details';
    PageType = CardPart;
    Editable = false;
    ApplicationArea = All;
    SourceTable = "BSB Book";

    layout
    {
        area(Content)
        {
            field("No."; Rec."No.")
            {
                Caption = 'Book No.';
                ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                trigger OnDrillDown()
                begin
                    ShowDetail();
                end;
            }
            field(Description; Rec.Description)
            {
                Caption = 'Book Description';
                ToolTip = 'Specifies the value of the Description field.', Comment = '%';
            }
            field("Date of Publishing"; Rec."Date of Publishing")
            {
                ToolTip = 'Specifies the value of the Date of Publishing field.', Comment = '%';
            }
            field("No. of Pages"; Rec."No. of Pages")
            {
                ToolTip = 'Specifies the value of the No. of Pages field.', Comment = '%';
            }
            field(Author; Rec.Author)
            {
                ToolTip = 'Specifies the value of the Author field.', Comment = '%';
            }
        }
    }

    local procedure ShowDetail()
    begin
        Rec.ShowCard();
    end;
}