# Producer-Consumer Problem

## Overview

The Producer-Consumer problem is a classic synchronization challenge encountered in operating systems. This project demonstrates a solution to this problem by synchronizing two threads: a Producer and a Consumer, using a fixed-size buffer.

## Problem Description

The Producer-Consumer problem involves a shared buffer of fixed size and two types of processes:

Producer Process: Creates items and adds them to the buffer.
Consumer Process: Removes items from the buffer and processes them.
The primary goal is to ensure that the Producer does not add items to a full buffer and that the Consumer does not remove items from an empty buffer. This synchronization prevents race conditions and ensures smooth operation between the two processes.

### How It Works

### Producer Process:
Continuously produces items.
Adds items to the buffer.
Stops producing when the buffer is full (buffer contains 3 items).


### Consumer Process:
Continuously consumes items from the buffer.
Can only consume items if they exist in the buffer.
Signals the Producer to resume production when an item is consumed, making space in the buffer.
Implementation Details

### Buffer Size: 
The buffer is of a fixed size (3 items).

### Synchronization: 
Utilizes thread synchronization mechanisms to coordinate the actions of the Producer and Consumer, ensuring thread-safe operations.

Features
Demonstrates the classic Producer-Consumer synchronization problem.
Showcases thread synchronization without focusing on architecture or animation.
Simple and clear implementation suitable for educational purposes and understanding basic synchronization concepts.
 

Full descritions here: 
https://www.educative.io/answers/what-is-the-producer-consumer-problem
