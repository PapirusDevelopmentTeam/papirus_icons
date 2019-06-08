package io.github.PapirusDevelopmentTeam.papirus_icons.activities;

import android.support.annotation.NonNull;

import com.dm.material.dashboard.candybar.activities.CandyBarSplashActivity;
import com.dm.material.dashboard.candybar.activities.configurations.SplashScreenConfiguration;
import io.github.PapirusDevelopmentTeam.papirus_icons.R;

public class SplashActivity extends CandyBarSplashActivity {

    @NonNull
    @Override
    public SplashScreenConfiguration onInit() {
        return new SplashScreenConfiguration(MainActivity.class)
                .setBottomText(getString(R.string.splash_screen_title));
    }
}
