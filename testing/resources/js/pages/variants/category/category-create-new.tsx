import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import AppLayout from '@/layouts/app-layout';
import { get_category } from '@/routes';
import { type BreadcrumbItem } from '@/types';
import { Head, useForm } from '@inertiajs/react';
import { Plus, X } from 'lucide-react'; // icons for add/remove
import React from 'react';

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Add New Category',
        href: 'create',
    },
];

export default function CategoryCreateNew() {
    const { data, setData, processing, post } = useForm({
        name: [''],
    });

    const handleChange = (index: number, value: string) => {
        const updated = [...data.name];
        updated[index] = value;
        setData('name', updated);
    };

    const addField = () => {
        setData('name', [...data.name, '']);
    };

    const removeField = (index: number) => {
        const updated = data.name.filter((_, i) => i !== index);
        setData('name', updated);
    };

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        post(get_category().url);
    };

    return (
        <AppLayout breadcrumbs={breadcrumbs}>
            <Head title="Add New category" />
            <div className="flex h-full flex-1 flex-col gap-4 overflow-x-auto rounded-xl p-4">
                <div className="relative min-h-[100vh] flex-1 overflow-hidden rounded-xl border border-sidebar-border/70 md:min-h-min dark:border-sidebar-border">
                    <form
                        onSubmit={handleSubmit}
                        className="flex h-full flex-col space-y-6 p-5"
                    >
                        <div className="flex flex-col gap-4">
                            <Label htmlFor="title" className="pb-2">
                                Brand category
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
                                        placeholder={`Category ${index + 1}`}
                                        value={value}
                                        onChange={(e) =>
                                            handleChange(index, e.target.value)
                                        }
                                        className="h-12"
                                    />
                                    {data.name.length > 1 && (
                                        <Button
                                            type="button"
                                            variant="destructive"
                                            size="icon"
                                            onClick={() => removeField(index)}
                                        >
                                            <X className="" />
                                        </Button>
                                    )}
                                </div>
                            ))}

                            <Button
                                type="button"
                                variant="secondary"
                                className="mt-2 flex items-center gap-2"
                                onClick={addField}
                            >
                                <Plus className="h-4 w-4" /> Add More
                            </Button>
                        </div>

                        <div className="flex items-center justify-end gap-4">
                            <Button disabled={processing} className="w-[300px]">
                                Save
                            </Button>
                        </div>
                    </form>
                </div>
            </div>
        </AppLayout>
    );
}
