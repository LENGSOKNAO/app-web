<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Images extends Model
{
    protected $table = 'images';

    protected $fillable = ['banners_id', 'sliders_id', 'banner_app_id', 'slider_app_id', 'file_path'];

    public function banner(): BelongsTo
    {
        return $this->belongsTo(Banners::class, 'banners_id');
    }

    public function bannerApp(): BelongsTo
    {
        return $this->belongsTo(BannerApp::class, 'banner_app_id');
    }

    public function slider(): BelongsTo
    {
        return $this->belongsTo(Sliders::class, 'sliders_id');
    }
    
    public function sliderApp(): BelongsTo
    {
        return $this->belongsTo(SliderApp::class, 'slider_app_id');
    }
}
