
using System;
using System.Collections.Generic;

namespace SudokuSolver.Core
{
    public sealed class GridCollection
    {
        public GridCollection(Grid grid) => m_Grids.AddFirst(grid);

        public Grid Now => m_Grids.First!.Value;

        public void Push(Grid grid) => m_Grids.AddFirst(grid);

        public void Pop()
        {
            m_Grids.RemoveFirst();
            
            int PopCountLimit() => m_Grids.First!.Value.Dimension
                                 * m_Grids.First!.Value.Dimension;

            if ( m_Grids.Count < 1 || ++m_PopCount < PopCountLimit()) return;

            m_PopCount = 0;
            
            var node = GetRandomNode();
            
            m_Grids.Remove(node);
                
            m_Grids.AddFirst(node.Value);
        }

        public int Count => m_Grids.Count;
        
        private LinkedListNode<Grid> GetRandomNode()
        {
            var index = m_Random.Next(0, m_Grids.Count);

            LinkedListNode<Grid> node;
            
            if (index <= m_Grids.Count / 2)
            {
                node = m_Grids.First!;
                
                while (index-- > 0) node = node.Next!;
            }
            else
            {
                node = m_Grids.Last!;
                
                index = m_Grids.Count - index;
                
                while (--index > 0) node = node.Previous!;
            }
            
            return node;
        }

        private readonly LinkedList<Grid> m_Grids = new ();
        
        private int m_PopCount;
        
        private readonly Random m_Random = new (0);
    }
}