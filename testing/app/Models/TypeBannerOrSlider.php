<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;


class TypeBannerOrSlider extends Model
{
    protected $table = 'category_banner_and_slider';

    protected $fillable = [
        "banners_id",
        "sliders_id",
        "banner_app_id",
        "slider_app_id",
        "category"
    ];


    public function Banner(): BelongsTo
    {
        return $this->belongsTo(Banners::class, 'banners_id');
    }

    public function Slider(): BelongsTo
    {
        return $this->belongsTo(Sliders::class, 'sliders_id');
    }

    public function bannerApp(): BelongsTo
    {
        return $this->belongsTo(BannerApp::class, 'banner_app_id');
    }

    public function sliderApp(): BelongsTo
    {
        return $this->belongsTo(SliderApp::class, 'slider_app_id');
    }
}
