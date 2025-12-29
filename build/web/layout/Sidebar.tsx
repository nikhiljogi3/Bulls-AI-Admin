import React from 'react';

const Sidebar: React.FC = () => {
  return (
    <aside style={{width: 250, padding: 16, borderRight: '1px solid #eee'}}>
      <nav>
        <ul style={{listStyle: 'none', padding: 0, margin: 0}}>
          <li>Dashboard</li>
          <li>Courses</li>
          <li>Settings</li>
        </ul>
      </nav>
    </aside>
  );
};

export default Sidebar;
