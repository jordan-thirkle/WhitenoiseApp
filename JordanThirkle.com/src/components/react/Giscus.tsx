import React, { useEffect, useRef } from 'react';

export const Giscus: React.FC = () => {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const script = document.createElement('script');
    script.src = 'https://giscus.app/client.js';
    script.setAttribute('data-repo', import.meta.env.PUBLIC_GISCUS_REPO || 'jordan-thirkle/creator-hub-comments');
    script.setAttribute('data-repo-id', import.meta.env.PUBLIC_GISCUS_REPO_ID || 'R_kgDOSLv_Ag');
    script.setAttribute('data-category', import.meta.env.PUBLIC_GISCUS_CATEGORY || 'Announcements');
    script.setAttribute('data-category-id', import.meta.env.PUBLIC_GISCUS_CATEGORY_ID || 'DIC_kwDOSLv_As4C7nrE');
    script.setAttribute('data-mapping', 'pathname');
    script.setAttribute('data-strict', '0');
    script.setAttribute('data-reactions-enabled', '1');
    script.setAttribute('data-emit-metadata', '0');
    script.setAttribute('data-input-position', 'top');
    script.setAttribute('data-theme', 'transparent_dark');
    script.setAttribute('data-lang', 'en');
    script.setAttribute('crossorigin', 'anonymous');
    script.async = true;

    if (ref.current) {
      ref.current.appendChild(script);
    }
  }, []);

  return <div ref={ref} id="giscus-container" className="min-h-[400px]" />;
};
