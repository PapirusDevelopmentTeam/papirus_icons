package io.github.PapirusDevelopmentTeam.papirus_icons.activities;

import android.support.annotation.NonNull;

import com.dm.material.dashboard.candybar.activities.CandyBarMuzeiActivity;
import io.github.PapirusDevelopmentTeam.papirus_icons.services.MuzeiService;

public class MuzeiActivity extends CandyBarMuzeiActivity {

    @NonNull
    @Override
    public Class<?> onInit() {
        return MuzeiService.class;
    }
}
