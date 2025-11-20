import { ChartAreaInteractive } from '@/components/chart-area-interactive';
import { DataTable, Order } from '@/components/data-table';
import { SectionCards } from '@/components/section-cards';
import { SidebarInset } from '@/components/ui/sidebar';
import AppLayout from '@/layouts/app-layout';
import { dashboard } from '@/routes';
import { type BreadcrumbItem } from '@/types';
import { Head } from '@inertiajs/react';
const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Dashboard',
        href: dashboard().url,
    },
];

interface PropsOrder {
    order: Order[];
}

export default function Dashboard({ order }: PropsOrder) {
    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title="Dashboard" />
            <SidebarInset>
                <div className="flex flex-1 flex-col">
                    <div className="@container/main flex flex-1 flex-col gap-2">
                        <div className="flex flex-col gap-4 py-4 md:gap-6 md:py-6">
                            <SectionCards />
                            <div className="px-4 lg:px-6">
                                <ChartAreaInteractive />
                            </div>
                            <DataTable order={order} />
                        </div>
                    </div>
                </div>
            </SidebarInset>
        </AppLayout>
    );
}
