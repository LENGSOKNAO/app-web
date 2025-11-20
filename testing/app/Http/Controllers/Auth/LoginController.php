<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class LoginController extends Controller
{
    public function store(LoginRequest $request): RedirectResponse
    {
        // This calls $request->authenticate() internally
        $request->authenticate();

        $user = Auth::user();

        // Restrict login to admins only
        if ($user->role !== 'admin') {
            Auth::guard('web')->logout();

            // For Inertia: throw validation exception so errors show in form
            throw \Illuminate\Validation\ValidationException::withMessages([
                'email' => 'Your account is not authorized for administrative login.',
            ]);
        }

        // Regenerate session
        $request->session()->regenerate();
        // Redirect to intended dashboard
        return redirect()->intended(route('dashboard', absolute: false));
    }
    
}