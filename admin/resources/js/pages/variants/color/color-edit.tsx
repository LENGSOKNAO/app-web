import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import AppLayout from '@/layouts/app-layout';
import { type BreadcrumbItem } from '@/types';
import { Head, useForm } from '@inertiajs/react';
import React from 'react';

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Edit',
        href: 'create',
    },
];

interface Color {
    id: number;
    name: string;
}

interface Props {
    color: Color;
}

export default function ColorEdit({ color }: Props) {
    const { data, setData, processing, put } = useForm({
        name: [color.name],
    });

    const handleChange = (index: number, value: string) => {
        const updated = [...data.name];
        updated[index] = value;
        setData('name', updated);
    };

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        put(`/color/${color.id}`);
    };

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title="Edit" />
            <div className="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
                <div className="relative min-h-[100vh] flex-1 overflow-hidden rounded-xl border border-sidebar-border/70 md:min-h-min dark:border-sidebar-border">
                    <form
                        onSubmit={handleSubmit}
                        className="flex h-full flex-col space-y-6 p-5"
                    >
                        <div className="flex flex-col gap-4">
                            <Label htmlFor="title" className="pb-2">
                                Brand Names
                            </Label>

                            {data.name.map((value, index) => (
                                <div
                                    key={index}
                                    className="flex items-center gap-2"
                                >
                                    <Input
                                        id={`name-${index}`}
                                        name={`name[${index}]`}
                                        type="text"
                                        placeholder={`Brand ${index + 1}`}
                                        value={value}
                                        onChange={(e) =>
                                            handleChange(index, e.target.value)
                                        }
                                        className="h-12"
                                    />
                                </div>
                            ))}
                        </div>

                        <div className="flex items-center justify-end gap-4">
                            <Button disabled={processing} className="w-[300px]">
                                Update
                            </Button>
                        </div>
                    </form>
                </div>
            </div>
        </AppLayout>
    );
}
