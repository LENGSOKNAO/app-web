import { NavFooter } from '@/components/nav-footer';
import { NavMain } from '@/components/nav-main';
import { NavUser } from '@/components/nav-user';
import {
    Sidebar,
    SidebarContent,
    SidebarFooter,
    SidebarHeader,
    SidebarMenu,
    SidebarMenuButton,
    SidebarMenuItem,
} from '@/components/ui/sidebar';
import { Link } from '@inertiajs/react';
import {
    Coins,
    Folder,
    FolderTree,
    Heart,
    Image,
    Layers,
    LayoutGrid,
    Package,
    Palette,
    Ruler,
    ShoppingCart,
    Store,
    Tag,
    Truck,
    Users,
} from 'lucide-react';
import AppLogo from './app-logo';

// ROUTES
import {
    banner,
    customer,
    dashboard,
    get_banner,
    get_brand,
    get_category,
    get_color,
    get_coupons,
    get_size,
    get_tax,
    order,
    product,
    s_a,
    shipping,
    slider,
    wishlist,
} from '@/routes';
import { type NavItem } from '@/types';

// PLATFORM
const mainNavItems: NavItem[] = [
    { title: 'Dashboard', href: dashboard(), icon: LayoutGrid },
    { title: 'Products', href: product(), icon: Package },
    { title: 'Colors', href: get_color(), icon: Palette },
    { title: 'Sizes', href: get_size(), icon: Ruler },
    { title: 'Brands', href: get_brand(), icon: Store },
    { title: 'Categories', href: get_category(), icon: FolderTree },
    { title: 'Coupons', href: get_coupons(), icon: Tag },
    { title: 'Taxes', href: get_tax(), icon: Coins },
    { title: 'Shipping', href: shipping(), icon: Truck },
];

// WEB
const web: NavItem[] = [
    { title: 'Banners', href: banner(), icon: Image },
    { title: 'Sliders', href: slider(), icon: Layers },
];

// APP
const app: NavItem[] = [
    { title: 'Banners', href: get_banner(), icon: Image },
    { title: 'Sliders', href: s_a(), icon: Layers },
];

// CUSTOMERS
const user: NavItem[] = [
    { title: 'Orders', href: order(), icon: ShoppingCart },
    { title: 'Customers', href: customer(), icon: Users },
    { title: 'Wishlist', href: wishlist(), icon: Heart },
];

// FOOTER LINKS
const footerNavItems: NavItem[] = [
    {
        title: 'Leng soknao',
        href: 'https://www.linkedin.com/in/leng-soknao-1771aa2b0/',
        icon: Folder,
    },
];

export function AppSidebar() {
    return (
        <Sidebar collapsible="icon" variant="inset">
            <SidebarHeader>
                <SidebarMenu>
                    <SidebarMenuItem>
                        <SidebarMenuButton size="lg" asChild>
                            <Link href={dashboard()} prefetch>
                                <AppLogo />
                            </Link>
                        </SidebarMenuButton>
                    </SidebarMenuItem>
                </SidebarMenu>
            </SidebarHeader>

            <SidebarContent>
                <NavMain name="Platform" items={mainNavItems} />
                <NavMain name="Web" items={web} />
                <NavMain name="APP" items={app} />
                <NavMain name="Customer" items={user} />
            </SidebarContent>

            <SidebarFooter>
                <NavFooter items={footerNavItems} className="mt-auto" />
                <NavUser />
            </SidebarFooter>
        </Sidebar>
    );
}
