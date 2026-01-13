# 👹 Level 8: Shadow of the Wraith (LD_PRELOAD Shadowing)
## Overview

The Shadow of the Wraith introduces runtime command interception using LD_PRELOAD. Standard commands may be overridden by malicious libraries, giving the illusion of normal behavior while masking the true state of the system. Students must discover and remove the shadowing to regain normal control.

This dungeon emphasizes runtime analysis and dynamic code manipulation rather than static process termination.

**Skills Practiced**

- Inspecting environment variables such as LD_PRELOAD
- Recognizing command shadowing and runtime interception
- Safely restoring normal command behavior without affecting the shell
- Extracting, decrypting, and interpreting cryptic, multi-layered hints
- Applying investigative and problem-solving skills to detect subtle persistence mechanisms
- Understanding advanced Linux attack and defense techniques in a controlled environment
