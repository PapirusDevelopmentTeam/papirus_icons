package io.github.PapirusDevelopmentTeam.papirus_icons.activities;

import androidx.annotation.NonNull;

import candybar.lib.activities.CandyBarMainActivity;

import io.github.PapirusDevelopmentTeam.papirus_icons.licenses.License;

public class MainActivity extends CandyBarMainActivity {

    @NonNull
    @Override
    public ActivityConfiguration onInit() {
        return new ActivityConfiguration()
                .setLicenseCheckerEnabled(License.isLicenseCheckerEnabled())
                .setLicenseKey(License.getLicenseKey())
                .setRandomString(License.getRandomString())
                .setDonationProductsId(License.getDonationProductsId())
                .setPremiumRequestProducts(License.getPremiumRequestProductsId(), License.getPremiumRequestProductsCount());
    }
}
