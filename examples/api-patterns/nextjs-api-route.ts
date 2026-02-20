/**
 * Next.js API Route Pattern (Token Optimization - External Example)
 *
 * Reference this file instead of embedding in agent instructions.
 * Agents: Read this when implementing API routes, don't copy from agent file.
 */

import { NextResponse } from 'next/server';
import { z } from 'zod';

// 1. Define Zod validation schema
const RegisterRequestSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  name: z.string().min(2, 'Name must be at least 2 characters')
});

type RegisterRequest = z.infer<typeof RegisterRequestSchema>;

// 2. API Route Handler
export async function POST(request: Request) {
  try {
    // Parse and validate request body
    const body = await request.json();
    const parsed = RegisterRequestSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'VALIDATION_ERROR',
            message: 'Invalid input',
            details: parsed.error.errors
          }
        },
        { status: 400 }
      );
    }

    // Business logic
    const result = await createUser(parsed.data);

    // Success response
    return NextResponse.json(
      {
        success: true,
        data: result
      },
      { status: 201 }
    );

  } catch (error) {
    // Error handling
    return handleApiError(error);
  }
}

// 3. Business logic (separate from route handler)
async function createUser(data: RegisterRequest) {
  // Implementation...
  return { id: '123', ...data };
}

// 4. Centralized error handler
function handleApiError(error: unknown) {
  console.error('API Error:', error);

  if (error instanceof ApiError) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: error.code,
          message: error.message
        }
      },
      { status: error.statusCode }
    );
  }

  // Generic error
  return NextResponse.json(
    {
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'An unexpected error occurred'
      }
    },
    { status: 500 }
  );
}

// 5. Custom error class
class ApiError extends Error {
  constructor(
    public code: string,
    public statusCode: number,
    message: string
  ) {
    super(message);
  }
}
