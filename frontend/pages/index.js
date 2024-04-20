// pages/redis.js

import React from 'react';

export default function RedisPage({ data }) {
  return (
    <div>
      <h1>Redis 데이터</h1>
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </div>
  );
}

export async function getServerSideProps() {
  try {
    const backendUrl = process.env.NEXT_PUBLIC_BACKEND_URL;
    const res = await fetch(`${backendUrl}/redis`);
    const data = await res.json();

    return {
      props: {
        data
      }
    };
  } catch (error) {
    console.error("API에서 데이터를 가져오는 데 실패했습니다.", error);
    return {
      props: {
        data: {}
      }
    };
  }
}
