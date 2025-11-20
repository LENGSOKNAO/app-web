<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Hash;

class UserDeleteController extends Controller
{
    /**
     * Delete the user's account.
     */
    public function destroy(Request $request, User $user)
    {
        if ($user->role === 'admin') {
            return redirect()->back()->with('error', 'You cannot delete an admin account.');
        }

        $request->validate([
           'password' => 'required',
        ]);

        if (!Hash::check($request->password, Auth::user()->password)) {
            return back()->withErrors([
                'password' => 'Password is incorrect.'
            ]);
        }
        
        $user->delete();

         return redirect()->route('customer');
    }
}
