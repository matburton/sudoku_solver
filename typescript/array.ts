
export function newArray<T>(length: number, factory: (index: number) => T): T[] {

    const array = new Array(length);

    for (let index = 0; index < length; ++index) {

        array[index] = factory(index);
    }

    return array;
}