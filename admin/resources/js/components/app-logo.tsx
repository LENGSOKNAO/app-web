import { SharedData } from '@/types';
import { usePage } from '@inertiajs/react';

export default function AppLogo() {
    const { auth } = usePage<SharedData>().props;

    return (
        <>
            <div className="relative flex aspect-square size-8 items-center justify-center rounded-md bg-sidebar-primary text-sidebar-primary-foreground">
                {auth.user.profile ? (
                    <img
                        className="h-full w-full rounded-sm object-cover"
                        src={`http://localhost:8000/storage/profiles/${auth.user.profile}`}
                        alt=""
                    />
                ) : (
                    <div className="absolute text-[7px] text-black">
                        No profile
                    </div>
                )}
            </div>
            <div className="ml-1 grid flex-1 text-left text-sm">
                <span className="mb-0.5 truncate leading-tight font-semibold">
                    {`${auth.user.first_name} `}
                    {auth.user.last_name}
                </span>
            </div>
        </>
    );
}
