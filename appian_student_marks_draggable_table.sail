/*
 * ============================================================================
 * APPIAN STUDENT MARKS TABLE — DRAG & DROP + ANALYTICS
 * ============================================================================
 * Purpose  : Display student marks for Class 10-A with drag-and-drop
 *            row reordering, subject-wise statistics, and topper
 *            highlighting.
 *
 * Features :
 *   1. a!gridField with isDragAndDropEnabled: true  (Appian drag-and-drop)
 *   2. Five subjects: Math, Science, English, Hindi, Social Studies
 *   3. Auto-ranked students; Rank 1 (Topper) highlighted in gold
 *   4. Red colour for individual scores below 60 (fail threshold)
 *   5. Subject-wise Sum, Average, Max and Min in a summary grid
 *   6. Class statistics: Total students, Class avg %, Highest / Lowest
 *
 * Drag-and-Drop Reference:
 *   https://docs.appian.com/suite/help/latest/a_gridField.html
 *   Property : isDragAndDropEnabled (Boolean, default false)
 *   Behaviour: When a row is dropped in a new position, saveInto receives
 *              the fully reordered array, updating the display instantly.
 * ============================================================================
 */
a!localVariables(

  /* -----------------------------------------------------------------------
   * STUDENT MARKS DATA
   * 8 students — each record holds per-subject scores (out of 100),
   * pre-computed Total (out of 500), Average %, Grade, and Class Rank.
   *
   * Rank computation (by Total descending):
   *   478 → 1 | 445 → 2 | 435 → 3 | 400 → 4
   *   395 → 5 | 350 → 6 | 325 → 7 | 290 → 8
   * ----------------------------------------------------------------------- */
  local!studentMarks: {
    a!map(
      id: 1,  rollNo: "S001",  name: "Arjun Kumar",
      math: 85,  science: 78,  english: 82,  hindi: 80,  social: 75,
      total: 400,  average: 80.0,  grade: "B+",  rank: 4
    ),
    a!map(
      id: 2,  rollNo: "S002",  name: "Priya Singh",
      math: 98,  science: 95,  english: 97,  hindi: 92,  social: 96,
      total: 478,  average: 95.6,  grade: "A+",  rank: 1
    ),
    a!map(
      id: 3,  rollNo: "S003",  name: "Rajesh Patel",
      math: 72,  science: 68,  english: 75,  hindi: 70,  social: 65,
      total: 350,  average: 70.0,  grade: "B",   rank: 6
    ),
    a!map(
      id: 4,  rollNo: "S004",  name: "Neha Sharma",
      math: 91,  science: 88,  english: 85,  hindi: 87,  social: 84,
      total: 435,  average: 87.0,  grade: "A",   rank: 3
    ),
    a!map(
      id: 5,  rollNo: "S005",  name: "Vikram Mehta",
      math: 62,  science: 70,  english: 68,  hindi: 65,  social: 60,
      total: 325,  average: 65.0,  grade: "C+",  rank: 7
    ),
    a!map(
      id: 6,  rollNo: "S006",  name: "Ananya Gupta",
      math: 88,  science: 92,  english: 90,  hindi: 86,  social: 89,
      total: 445,  average: 89.0,  grade: "A",   rank: 2
    ),
    a!map(
      id: 7,  rollNo: "S007",  name: "Rohan Verma",
      math: 55,  science: 60,  english: 65,  hindi: 58,  social: 52,
      total: 290,  average: 58.0,  grade: "C",   rank: 8
    ),
    a!map(
      id: 8,  rollNo: "S008",  name: "Deepika Nair",
      math: 78,  science: 82,  english: 79,  hindi: 76,  social: 80,
      total: 395,  average: 79.0,  grade: "B+",  rank: 5
    )
  },

  /* -----------------------------------------------------------------------
   * SUBJECT-WISE AGGREGATE STATISTICS  (pre-computed for 8 students)
   *
   * Subject Sums:
   *   Math    : 85+98+72+91+62+88+55+78  = 629
   *   Science : 78+95+68+88+70+92+60+82  = 633
   *   English : 82+97+75+85+68+90+65+79  = 641
   *   Hindi   : 80+92+70+87+65+86+58+76  = 614
   *   Social  : 75+96+65+84+60+89+52+80  = 601
   *   Grand Total (all 8 students × 5 subjects) = 3118
   *
   * Subject Averages (sum ÷ 8 students):
   *   Math 78.6 | Science 79.1 | English 80.1 | Hindi 76.8 | Social 75.1
   *
   * Class Average per student: 3118 ÷ 8 = 389.75 / 500  (77.95%)
   * ----------------------------------------------------------------------- */
  local!subjectSums: a!map(
    math: 629,   science: 633,  english: 641,  hindi: 614,  social: 601,
    grand: 3118
  ),
  local!subjectAvgs: a!map(
    math: 78.6,  science: 79.1,  english: 80.1,  hindi: 76.8,  social: 75.1
  ),
  local!subjectMax: a!map(
    math: 98,  science: 95,  english: 97,  hindi: 92,  social: 96
  ),
  local!subjectMin: a!map(
    math: 55,  science: 60,  english: 65,  hindi: 58,  social: 52
  ),

  /* Class-level aggregates */
  local!totalStudents:   8,
  local!classAvgTotal:   389.75,
  local!classAvgPercent: 77.95,

  {
    /* ==================================================================== */
    /* PAGE HEADER                                                           */
    /* ==================================================================== */
    a!richTextDisplayField(
      value: {
        a!richTextItem(text: "📊 ", size: "LARGE"),
        a!richTextItem(
          text: "Class 10-A  —  Student Marks Report",
          style: "STRONG",
          size: "LARGE",
          color: "#185FA5"
        )
      },
      align: "CENTER"
    ),
    a!richTextDisplayField(
      value: {
        a!richTextItem(
          text: "Academic Year 2025-26  |  Total Students: 8  |  " &
                "Subjects: Mathematics · Science · English · Hindi · Social Studies",
          size: "MEDIUM",
          color: "#666666"
        )
      },
      align: "CENTER"
    ),

    /* ==================================================================== */
    /* TOPPER SPOTLIGHT                                                      */
    /* ==================================================================== */
    a!sectionLayout(
      label: "🏆 Class Topper",
      contents: {
        a!columnsLayout(
          columns: {
            /* Identity */
            a!columnLayout(
              contents: {
                a!richTextDisplayField(
                  value: {
                    a!richTextItem(text: "Name:     ",  style: "STRONG"),
                    a!richTextItem(
                      text: "Priya Singh",
                      color: "#D4AF37",
                      style: "STRONG"
                    ),
                    a!richTextItem(text: char(10)),
                    a!richTextItem(text: "Roll No:  ",  style: "STRONG"),
                    a!richTextItem(text: "S002"),
                    a!richTextItem(text: char(10)),
                    a!richTextItem(text: "Rank:     ",  style: "STRONG"),
                    a!richTextItem(
                      text: "🥇 1st in Class",
                      color: "#D4AF37",
                      style: "STRONG"
                    )
                  }
                )
              }
            ),
            /* Score summary */
            a!columnLayout(
              contents: {
                a!richTextDisplayField(
                  value: {
                    a!richTextItem(text: "Total:   ",  style: "STRONG"),
                    a!richTextItem(
                      text: "478 / 500",
                      color: "#2E8B57",
                      style: "STRONG"
                    ),
                    a!richTextItem(text: char(10)),
                    a!richTextItem(text: "Average: ",  style: "STRONG"),
                    a!richTextItem(
                      text: "95.6%",
                      color: "#2E8B57",
                      style: "STRONG"
                    ),
                    a!richTextItem(text: char(10)),
                    a!richTextItem(text: "Grade:   ",  style: "STRONG"),
                    a!richTextItem(
                      text: "A+",
                      color: "#D4AF37",
                      style: "STRONG"
                    )
                  }
                )
              }
            ),
            /* Per-subject breakdown */
            a!columnLayout(
              contents: {
                a!richTextDisplayField(
                  value: {
                    a!richTextItem(text: "Math: ",       style: "STRONG"),
                    a!richTextItem(text: "98",           color: "#2E8B57"),
                    a!richTextItem(text: "   Science: ", style: "STRONG"),
                    a!richTextItem(text: "95",           color: "#2E8B57"),
                    a!richTextItem(text: char(10)),
                    a!richTextItem(text: "English: ",    style: "STRONG"),
                    a!richTextItem(text: "97",           color: "#2E8B57"),
                    a!richTextItem(text: "   Hindi: ",   style: "STRONG"),
                    a!richTextItem(text: "92",           color: "#2E8B57"),
                    a!richTextItem(text: char(10)),
                    a!richTextItem(text: "Social: ",     style: "STRONG"),
                    a!richTextItem(text: "96",           color: "#2E8B57")
                  }
                )
              }
            )
          }
        )
      }
    ),

    /* ==================================================================== */
    /* CLASS STATISTICS SUMMARY CARDS                                       */
    /* ==================================================================== */
    a!sectionLayout(
      label: "Class Statistics",
      isCollapsible: true(),
      isInitiallyCollapsed: false,
      contents: {
        a!columnsLayout(
          columns: {
            a!columnLayout(
              contents: {
                a!textField(
                  label: "Total Students",
                  value: local!totalStudents,
                  readOnly: true
                ),
                a!textField(
                  label: "Class Average %",
                  value: local!classAvgPercent & "%",
                  readOnly: true
                )
              }
            ),
            a!columnLayout(
              contents: {
                a!textField(
                  label: "Class Average (Total Marks)",
                  value: local!classAvgTotal & " / 500",
                  readOnly: true
                ),
                a!textField(
                  label: "Grand Total (All Marks Combined)",
                  value: local!subjectSums.grand & " marks",
                  readOnly: true
                )
              }
            ),
            a!columnLayout(
              contents: {
                a!textField(
                  label: "Highest Score",
                  value: "478 / 500  (Priya Singh — Rank 1)",
                  readOnly: true
                ),
                a!textField(
                  label: "Lowest Score",
                  value: "290 / 500  (Rohan Verma — Rank 8)",
                  readOnly: true
                )
              }
            )
          }
        )
      }
    ),

    /* ==================================================================== */
    /* DRAG-AND-DROP STUDENT MARKS TABLE                                    */
    /*                                                                      */
    /* How Appian drag-and-drop works in a!gridField:                       */
    /*   • isDragAndDropEnabled: true                                        */
    /*       Renders a ⠿ drag handle on the left edge of every row.        */
    /*       Users grab the handle and drop the row at any position.        */
    /*   • saveInto: local!studentMarks                                     */
    /*       On drop, Appian writes the fully reordered array back into     */
    /*       local!studentMarks, causing the grid to refresh in place.      */
    /*                                                                      */
    /* Reference: Appian Docs › Interface Components › Grid Field           */
    /*   https://docs.appian.com/suite/help/latest/a_gridField.html         */
    /* ==================================================================== */
    a!sectionLayout(
      label: "Student Marks Table — Drag Rows to Reorder",
      contents: {
        a!richTextDisplayField(
          value: {
            a!richTextItem(
              text: "💡  Tip: Drag the  ⠿  handle on the left of any row to reorder students.  " &
                    "Topper row is highlighted in gold.  Red scores are below the 60-mark pass threshold.",
              size: "SMALL",
              color: "#555555",
              style: "EMPHASIS"
            )
          }
        ),

        a!gridField(
          label: "Student Marks",
          labelPosition: "COLLAPSED",
          data: local!studentMarks,
          columns: {

            /* ---- Rank -------------------------------------------------- */
            a!gridColumn(
              label: "Rank",
              sortField: "rank",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  if(
                    fv!row.rank = 1,
                    a!richTextItem(text: "🥇 1",  style: "STRONG", color: "#D4AF37"),
                    if(
                      fv!row.rank = 2,
                      a!richTextItem(text: "🥈 2",  style: "STRONG", color: "#A8A9AD"),
                      if(
                        fv!row.rank = 3,
                        a!richTextItem(text: "🥉 3",  style: "STRONG", color: "#CD7F32"),
                        a!richTextItem(text: "   " & fv!row.rank)
                      )
                    )
                  )
                }
              ),
              width: "ICON"
            ),

            /* ---- Roll Number ------------------------------------------- */
            a!gridColumn(
              label: "Roll No",
              sortField: "rollNo",
              value: fv!row.rollNo,
              width: "NARROW"
            ),

            /* ---- Student Name — gold for topper ----------------------- */
            a!gridColumn(
              label: "Student Name",
              sortField: "name",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  if(
                    fv!row.rank = 1,
                    a!richTextItem(
                      text: "🏆 " & fv!row.name,
                      style: "STRONG",
                      color: "#D4AF37"
                    ),
                    a!richTextItem(text: fv!row.name)
                  )
                }
              ),
              width: "MEDIUM"
            ),

            /* ---- Mathematics ------------------------------------------- */
            a!gridColumn(
              label: "Math (100)",
              sortField: "math",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(
                    text: fv!row.math,
                    style: if(fv!row.rank = 1, "STRONG", "NORMAL"),
                    color: if(
                      fv!row.rank = 1, "#D4AF37",
                      if(fv!row.math < 60, "#CC0000", "#333333")
                    )
                  )
                }
              ),
              width: "NARROW"
            ),

            /* ---- Science ----------------------------------------------- */
            a!gridColumn(
              label: "Science (100)",
              sortField: "science",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(
                    text: fv!row.science,
                    style: if(fv!row.rank = 1, "STRONG", "NORMAL"),
                    color: if(
                      fv!row.rank = 1, "#D4AF37",
                      if(fv!row.science < 60, "#CC0000", "#333333")
                    )
                  )
                }
              ),
              width: "NARROW"
            ),

            /* ---- English ----------------------------------------------- */
            a!gridColumn(
              label: "English (100)",
              sortField: "english",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(
                    text: fv!row.english,
                    style: if(fv!row.rank = 1, "STRONG", "NORMAL"),
                    color: if(
                      fv!row.rank = 1, "#D4AF37",
                      if(fv!row.english < 60, "#CC0000", "#333333")
                    )
                  )
                }
              ),
              width: "NARROW"
            ),

            /* ---- Hindi ------------------------------------------------- */
            a!gridColumn(
              label: "Hindi (100)",
              sortField: "hindi",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(
                    text: fv!row.hindi,
                    style: if(fv!row.rank = 1, "STRONG", "NORMAL"),
                    color: if(
                      fv!row.rank = 1, "#D4AF37",
                      if(fv!row.hindi < 60, "#CC0000", "#333333")
                    )
                  )
                }
              ),
              width: "NARROW"
            ),

            /* ---- Social Studies ---------------------------------------- */
            a!gridColumn(
              label: "Social (100)",
              sortField: "social",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(
                    text: fv!row.social,
                    style: if(fv!row.rank = 1, "STRONG", "NORMAL"),
                    color: if(
                      fv!row.rank = 1, "#D4AF37",
                      if(fv!row.social < 60, "#CC0000", "#333333")
                    )
                  )
                }
              ),
              width: "NARROW"
            ),

            /* ---- Total out of 500 -------------------------------------- */
            a!gridColumn(
              label: "Total (500)",
              sortField: "total",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(
                    text: fv!row.total,
                    style: "STRONG",
                    color: if(
                      fv!row.rank = 1,   "#D4AF37",
                      if(fv!row.total >= 400, "#2E8B57",
                        if(fv!row.total >= 300, "#FF8C00", "#CC0000"))
                    )
                  )
                }
              ),
              width: "NARROW"
            ),

            /* ---- Average Percentage ------------------------------------ */
            a!gridColumn(
              label: "Avg %",
              sortField: "average",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(
                    text: fv!row.average & "%",
                    style: if(fv!row.rank = 1, "STRONG", "NORMAL"),
                    color: if(
                      fv!row.rank = 1,      "#D4AF37",
                      if(fv!row.average >= 80, "#2E8B57",
                        if(fv!row.average >= 60, "#FF8C00", "#CC0000"))
                    )
                  )
                }
              ),
              width: "NARROW"
            ),

            /* ---- Grade ------------------------------------------------- */
            a!gridColumn(
              label: "Grade",
              sortField: "grade",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(
                    text: fv!row.grade,
                    style: "STRONG",
                    color: if(
                      fv!row.rank = 1, "#D4AF37",
                      if(
                        or(fv!row.grade = "A+", fv!row.grade = "A"),
                        "#2E8B57",
                        if(
                          or(fv!row.grade = "B+", fv!row.grade = "B"),
                          "#0066CC",
                          "#FF8C00"
                        )
                      )
                    )
                  )
                }
              ),
              width: "ICON"
            )

          },

          /*
           * DRAG-AND-DROP CONFIGURATION
           *
           * isDragAndDropEnabled: true
           *   Shows a ⠿ drag handle on the left side of each row.
           *   The user grabs the handle and drops the row at the desired
           *   position within the grid.
           *
           * saveInto: local!studentMarks
           *   When the user releases the row at its new position, Appian
           *   writes the reordered list back into local!studentMarks.
           *   The grid re-renders with the new order immediately.
           */
          isDragAndDropEnabled: true,
          saveInto: local!studentMarks,

          pageSize: 10,
          rowHeader: 3
        )
      }
    ),

    /* ==================================================================== */
    /* SUBJECT-WISE SUM & AVERAGE SUMMARY TABLE                             */
    /* ==================================================================== */
    a!sectionLayout(
      label: "Subject-Wise Aggregate Summary (Sum · Average · Max · Min)",
      isCollapsible: true(),
      isInitiallyCollapsed: false,
      contents: {
        a!gridField(
          label: "Subject Summary",
          labelPosition: "COLLAPSED",
          data: {
            a!map(
              statistic: "Class Sum  (all 8 students)",
              math:    local!subjectSums.math,
              science: local!subjectSums.science,
              english: local!subjectSums.english,
              hindi:   local!subjectSums.hindi,
              social:  local!subjectSums.social,
              overall: local!subjectSums.grand
            ),
            a!map(
              statistic: "Class Average",
              math:    local!subjectAvgs.math    & "%",
              science: local!subjectAvgs.science & "%",
              english: local!subjectAvgs.english & "%",
              hindi:   local!subjectAvgs.hindi   & "%",
              social:  local!subjectAvgs.social  & "%",
              overall: local!classAvgPercent     & "%"
            ),
            a!map(
              statistic: "Highest Score",
              math:    local!subjectMax.math,
              science: local!subjectMax.science,
              english: local!subjectMax.english,
              hindi:   local!subjectMax.hindi,
              social:  local!subjectMax.social,
              overall: 478
            ),
            a!map(
              statistic: "Lowest Score",
              math:    local!subjectMin.math,
              science: local!subjectMin.science,
              english: local!subjectMin.english,
              hindi:   local!subjectMin.hindi,
              social:  local!subjectMin.social,
              overall: 290
            )
          },
          columns: {
            a!gridColumn(
              label: "Statistic",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(text: fv!row.statistic, style: "STRONG")
                }
              ),
              width: "MEDIUM"
            ),
            a!gridColumn(label: "Math (100)",    value: fv!row.math,    width: "NARROW"),
            a!gridColumn(label: "Science (100)", value: fv!row.science, width: "NARROW"),
            a!gridColumn(label: "English (100)", value: fv!row.english, width: "NARROW"),
            a!gridColumn(label: "Hindi (100)",   value: fv!row.hindi,   width: "NARROW"),
            a!gridColumn(label: "Social (100)",  value: fv!row.social,  width: "NARROW"),
            a!gridColumn(
              label: "Overall",
              value: a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                value: {
                  a!richTextItem(
                    text: fv!row.overall,
                    style: "STRONG",
                    color: "#185FA5"
                  )
                }
              ),
              width: "NARROW"
            )
          },
          pageSize: 10
        ),

        /* Grade distribution line */
        a!richTextDisplayField(
          value: {
            a!richTextItem(
              text: char(10) & "Grade Distribution — ",
              style: "STRONG"
            ),
            a!richTextItem(text: "A+: 1  ", color: "#D4AF37", style: "STRONG"),
            a!richTextItem(text: "A: 2  ",  color: "#2E8B57", style: "STRONG"),
            a!richTextItem(text: "B+: 2  ", color: "#0066CC", style: "STRONG"),
            a!richTextItem(text: "B: 1  ",  color: "#0066CC"),
            a!richTextItem(text: "C+: 1  ", color: "#FF8C00"),
            a!richTextItem(text: "C: 1",    color: "#CC6600")
          }
        )
      }
    ),

    /* ==================================================================== */
    /* COLOUR CODE LEGEND                                                    */
    /* ==================================================================== */
    a!sectionLayout(
      label: "Colour Code Legend",
      isCollapsible: true(),
      isInitiallyCollapsed: true,
      contents: {
        a!richTextDisplayField(
          value: {
            a!richTextItem(text: "■ Gold   ", color: "#D4AF37", style: "STRONG"),
            a!richTextItem(text: "— Class Topper  (Rank 1 — name, all marks, grade)"    & char(10)),
            a!richTextItem(text: "■ Green  ", color: "#2E8B57", style: "STRONG"),
            a!richTextItem(text: "— Distinction   (score ≥ 80 or grade A / A+)"         & char(10)),
            a!richTextItem(text: "■ Blue   ", color: "#0066CC", style: "STRONG"),
            a!richTextItem(text: "— First Class   (grade B / B+)"                       & char(10)),
            a!richTextItem(text: "■ Orange ", color: "#FF8C00", style: "STRONG"),
            a!richTextItem(text: "— Pass          (score 60–79 or grade C+)"            & char(10)),
            a!richTextItem(text: "■ Red    ", color: "#CC0000", style: "STRONG"),
            a!richTextItem(text: "— Below 60      (needs improvement)"                  & char(10) & char(10)),
            a!richTextItem(text: "⠿  Drag handle — ", style: "STRONG"),
            a!richTextItem(
              text: "Visible on each row when isDragAndDropEnabled is true. " &
                    "Grab the handle and drop the row to reorder."
            )
          }
        )
      }
    ),

    /* ==================================================================== */
    /* PAGE FOOTER                                                           */
    /* ==================================================================== */
    a!richTextDisplayField(
      value: {
        a!richTextItem(
          text: "School Management System  |  Class 10-A  |  Academic Year 2025-26  |  " &
                "Generated: " & text(today(), "DD MMM YYYY"),
          size: "SMALL",
          color: "#888780"
        )
      },
      align: "CENTER"
    )

  }
)
