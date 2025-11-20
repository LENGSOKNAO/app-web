import { IconTrendingUp } from '@tabler/icons-react';

import { Badge } from '@/components/ui/badge';
import {
    Card,
    CardAction,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from '@/components/ui/card';
import { usePage } from '@inertiajs/react';

interface Order {
    total: number;
}

interface User {
    id: number;
    role: string;
}

interface Stock {
    stock: number;
}

interface OrderProps {
    order?: Order[];
}

interface UserProps {
    user?: User[];
}

interface StockProps {
    stock?: Stock[];
}

export function SectionCards() {
    const { order } = usePage().props as OrderProps;
    const { user } = usePage().props as UserProps;
    const { stock } = usePage().props as StockProps;

    const totalPriceOrder = order?.reduce((e, i) => e + Number(i.total), 0).toFixed(2);
    const totalOrder = order?.length;
    const totalUser = user?.filter((u) => u.role !== 'admin').length;
    const totalStock = stock?.reduce((e, i) => e + Number(i.stock), 0);

    return (
        <div className="grid grid-cols-1 gap-4 px-4 *:data-[slot=card]:bg-gradient-to-t *:data-[slot=card]:from-primary/5 *:data-[slot=card]:to-card *:data-[slot=card]:shadow-xs lg:px-6 @xl/main:grid-cols-2 @5xl/main:grid-cols-4 dark:*:data-[slot=card]:bg-card">
            <Card className="@container/card">
                <CardHeader>
                    <CardDescription>Total Revenue</CardDescription>
                    <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                        $ {totalPriceOrder}
                    </CardTitle>
                    <CardAction>
                        <Badge variant="outline">Price</Badge>
                    </CardAction>
                </CardHeader>
                <CardFooter className="flex-col items-start gap-1.5 text-sm">
                    <div className="line-clamp-1 flex gap-2 font-medium">
                        Revenue
                        <IconTrendingUp className="size-4" />
                    </div>
                    <div className="text-muted-foreground">
                        Compared to previous month's performance
                    </div>
                </CardFooter>
            </Card>
            <Card className="@container/card">
                <CardHeader>
                    <CardDescription>Total Order</CardDescription>
                    <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                        {totalOrder}
                    </CardTitle>
                    <CardAction>
                        <Badge variant="outline">Order</Badge>
                    </CardAction>
                </CardHeader>
                <CardFooter className="flex-col items-start gap-1.5 text-sm">
                    <div className="line-clamp-1 flex gap-2 font-medium">
                        Strong growth throughout the month{' '}
                        <IconTrendingUp className="size-4" />
                    </div>
                    <div className="text-muted-foreground">
                        Compared to previous month's performance
                    </div>
                </CardFooter>
            </Card>
            <Card className="@container/card">
                <CardHeader>
                    <CardDescription>Active Accounts</CardDescription>
                    <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                        {totalUser}
                    </CardTitle>
                    <CardAction>
                        <Badge variant="outline">Users</Badge>
                    </CardAction>
                </CardHeader>
                <CardFooter className="flex-col items-start gap-1.5 text-sm">
                    <div className="line-clamp-1 flex gap-2 font-medium">
                        Strong growth this month
                        <IconTrendingUp className="size-4" />
                    </div>
                    <div className="text-muted-foreground">
                        Review user acquisition strategies
                    </div>
                </CardFooter>
            </Card>
            <Card className="@container/card">
                <CardHeader>
                    <CardDescription>Stock</CardDescription>
                    <CardTitle className="text-2xl font-semibold tabular-nums @[250px]/card:text-3xl">
                        {totalStock}
                    </CardTitle>
                    <CardAction>
                        <Badge variant="outline">Products Stock</Badge>
                    </CardAction>
                </CardHeader>

                <CardFooter className="flex-col items-start gap-1.5 text-sm">
                    <div className="line-clamp-1 flex gap-2 font-medium">
                        Updated daily based on current inventory{' '}
                        <IconTrendingUp className="size-4" />
                    </div>
                    <div className="text-muted-foreground">
                        Last updated: {new Date().toLocaleDateString()}
                    </div>
                </CardFooter>
            </Card>
        </div>
    );
}
