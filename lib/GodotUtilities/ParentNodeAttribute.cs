using System;

namespace Godot
{
    [AttributeUsage(AttributeTargets.All, AllowMultiple = false)]
    public class ParentAttribute : Attribute
    {
        public ParentAttribute() { }
    }
}