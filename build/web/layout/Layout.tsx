import React from 'react';
import Header from './Header';
import Sidebar from './Sidebar';

const Layout: React.FC<{children?: React.ReactNode}> = ({children}) => {
  return (
    <div style={{display: 'flex', flexDirection: 'column', minHeight: '100vh'}}>
      <Header />
      <div style={{display: 'flex', flex: 1}}>
        <Sidebar />
        <main style={{flex: 1, padding: 16}}>{children}</main>
      </div>
    </div>
  );
};

export default Layout;
