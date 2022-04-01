
export default class DoubleLinkedList<T> {
   
    public get length(): number { return this.count; }

    public at(index: number): T | undefined {

        for (let node = index >= 0 ? this.first : this.last;
             node !== null;
             index > 0 ? --index : ++index) {

            if (index === 0 || index === -1) return node.element;

            node = index > 0 ? node.next : node.previous;
        }

        return undefined;
    }

    public push(element: T): number {

        this.last = { element: element, next: null, previous: this.last };

        if (this.last.previous === null) {
            
            this.first = this.last;
        }
        else {

            this.last.previous.next = this.last;
        }

        return ++this.count;
    }

    public pop(): T | undefined {

        if (this.last === null) return undefined;

        let element = this.last.element;

        this.last = this.last.previous;

        if (this.last === null) {

            this.first = null;
        }
        else {

            this.last.next = null;
        }

        --this.count;

        return element;
    }

    public unshift(element: T): number {

        this.first = { element: element, next: this.first, previous: null };

        if (this.first.next === null) {
            
            this.last = this.first;
        }
        else {

            this.first.next.previous = this.first;
        }

        return ++this.count;
    }

    public shift(): T | undefined {

        if (this.first === null) return undefined;

        let element = this.first.element;

        this.first = this.first.next;

        if (this.first === null) {

            this.last = null;
        }
        else {

            this.first.previous = null;
        }

        --this.count;

        return element;
    }

    private count: number = 0;

    private first: DoubleLinkedNode<T> | null = null;
    private last:  DoubleLinkedNode<T> | null = null;
}

interface DoubleLinkedNode<T> {

    readonly element: T;

    next:     DoubleLinkedNode<T> | null;
    previous: DoubleLinkedNode<T> | null;
}