package io.github.PapirusDevelopmentTeam.papirus_icons.applications;

import androidx.annotation.NonNull;

// TODO: Remove `//` below to enable OneSignal
//import com.onesignal.OneSignal;

import candybar.lib.applications.CandyBarApplication;

public class CandyBar extends CandyBarApplication {

    // TODO: Remove `/*` and `*/` below to enable OneSignal
    /*
    @Override
    public void onCreate() {
        super.onCreate();

        // OneSignal Initialization
        OneSignal.initWithContext(this);
        OneSignal.setAppId("YOUR_ONESIGNAL_APP_ID_HERE");
    }
    */

    @NonNull
    @Override
    public Configuration onInit() {
        // Sample configuration
        Configuration configuration = new Configuration();
        
        DonationLink[] donationLinks = new DonationLink[] {
        new DonationLink(
                // You can use png file (without extension) inside drawable-nodpi folder or url
                "apps_paypal",
                "PayPal",
                "Donate me on PayPal",
                "https://www.paypal.me/varlesh"),
        new DonationLink(
                // You can use png file (without extension) inside drawable-nodpi folder or url
                "apps_yoomoney",
                "YooMoney",
                "Donate me on YooMoney",
                "https://yoomoney.ru/to/410013316426627"),
        new DonationLink(
                // You can use png file (without extension) inside drawable-nodpi folder or url
                "apps_patreon",
                "Patreon",
                "Donate me on Patreon",
                "https://patreon.com/varlesh")
                };
        configuration.setDonationLinks(donationLinks);
        configuration.setGenerateAppFilter(true);
        configuration.setGenerateAppMap(true);
        configuration.setGenerateThemeResources(true);

        return configuration;
    }
}
