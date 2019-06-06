package io.github.papirusdevelopmentteam.android-icons.applications;

import android.support.annotation.NonNull;

import com.dm.material.dashboard.candybar.applications.CandyBarApplication;

public class CandyBar extends CandyBarApplication {
    
    @NonNull
    @Override
    public Configuration onInit() {
        //Sample configuration
        Configuration configuration = new Configuration();

        configuration.setGenerateAppFilter(true);
        configuration.setGenerateAppMap(true);
        configuration.setGenerateThemeResources(true);
        
        return configuration;
    }
}
