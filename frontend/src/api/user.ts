import { User } from '../schema';
import { ApiResponse, get, post } from './core';

export const getAllUsers = (): ApiResponse<User[]> => get<User[]>('users');
export const getUser = (id: number) => get<User>(`users/${id}`);

type UserParams = {
  name: string;
  password: string;
};

export const createUser = (params: UserParams) =>
  post<User>('users', { user: params });
