codeunit 50102 "BSB Notif. Subscriber Store"
{
    var
        MyNotifications: Record "My Notifications";
        CredLimitNotif: Notification;
        CredLimitNotifEditCustomerTxt: Label 'Edit Customer', Comment = 'de-DE=Debitor bearbeiten';
        CredLimitNotifIDTxt: label 'e5ce884c-b681-4680-b96d-bd0be633fa98', Locked = true;
        CredLimitNotifMsg: Label '%1 %2 of %3 %4 %5 is lager than %6', Comment = 'de-DE=%1 %2 of %3 %4 %5 is ist größer als %6';
        CreditLimitNotifDescTxt: Label 'Balance of customer is lager than the credit limit';
        CreditLimitNotifTxt: Label 'Customer balance exceeds credit limit';


    [EventSubscriber(ObjectType::Page, Page::"Sales Order", OnAfterGetCurrRecordEvent, '', false, false)]
    local procedure CheckCreditLimit(var Rec: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        if Rec."Bill-to Customer No." = '' then
            exit;
        Customer.SetAutoCalcFields("Balance (LCY)");
        Customer.Get(Rec."Bill-to Customer No.");
        if Customer."Credit Limit (LCY)" = 0 then
            exit;
        if (Customer."Balance (LCY)" > Customer."Credit Limit (LCY)") and
            MyNotifications.IsEnabledForRecord(CredLimitNotifIDTxt, Customer)
        then begin
            CredLimitNotif.Id := CredLimitNotifIDTxt;
            CredLimitNotif.Scope := CredLimitNotif.Scope::LocalScope;
            CredLimitNotif.Message(
                StrSubstNo(CredLimitNotifMsg,
                Customer.FieldCaption("Balance (LCY)"),
                Customer."Balance (LCY)",
                Customer.TableCaption,
                Customer."No.",
                Customer.Name,
                Customer."Credit Limit (LCY)")
            );
            CredLimitNotif.SetData('CustNo', Customer."No.");
            CredLimitNotif.AddAction(CredLimitNotifEditCustomerTxt, Codeunit::"BSB Notif. Subscriber Store", 'OpenCustomerCard');
            CredLimitNotif.Send();
        end;
    end;

    procedure OpenCustomerCard(Notification: Notification)
    var
        Customer: Record Customer;
    begin
        Customer.Get(Notification.GetData('CustNo'));
        Page.Run(Page::"Customer Card", Customer);
    end;

    [EventSubscriber(ObjectType::Page, Page::"My Notifications", OnInitializingNotificationWithDefaultState, '', false, false)]
    local procedure "My Notifications_OnInitializingNotificationWithDefaultState"()
    begin
        MyNotifications.InsertDefaultWithTableNum(CredLimitNotifIDTxt, CreditLimitNotifTxt, CreditLimitNotifDescTxt, Database::Customer);
    end;

}